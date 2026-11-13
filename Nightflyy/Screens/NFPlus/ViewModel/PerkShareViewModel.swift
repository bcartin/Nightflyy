//
//  PerkShareViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import AVFoundation
import OSLog
import SwiftUI

/// Drives the perk share camera: camera permission, tap for a photo or hold for a video,
/// and the branded photo or video to share.
@Observable @MainActor
final class PerkShareViewModel {

    enum CameraAccess {
        case unknown
        case granted
        case denied
    }

    /// How long the shutter must be held before it records instead of taking a photo.
    static let holdToRecordDelay: Duration = .milliseconds(300)

    let perk: NFPPerk
    let dateText: String
    let camera = CameraController()
    /// False in the Simulator, which has no camera; the shutter then uses a sample photo or video.
    let isCameraAvailable = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil
    let canFlipCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) != nil

    var usesFrontCamera = false
    var cameraAccess: CameraAccess = .unknown
    var venueImage: UIImage?
    var photo: UIImage?
    /// The photo with the branding drawn on, ready for the share sheet.
    var shareImage: Image?
    var isRecording = false
    /// True while the recorded clip is being cropped and branded.
    var isPreparingVideo = false
    /// The recorded video with the branding burned in, ready for the share sheet.
    var shareVideo: URL?
    /// Loops the finished video on the card.
    var videoPlayer: AVQueuePlayer?
    /// Size of the on-screen card, so the shared photo or video matches what the user saw.
    var cardSize: CGSize = .zero

    /// A finished photo or video is showing instead of the camera.
    var hasResult: Bool {
        photo != nil || videoPlayer != nil
    }

    private var holdTask: Task<Void, Never>?
    private var pressStartedRecording = false
    private var videoLooper: AVPlayerLooper?

    init(perk: NFPPerk, redeemedDate: Date = .now) {
        self.perk = perk
        self.dateText = Self.dateText(for: redeemedDate)
    }

    /// For example "Monday, Nov 2".
    static func dateText(for date: Date, locale: Locale = .current) -> String {
        date.formatted(Date.FormatStyle(locale: locale).weekday(.wide).month(.abbreviated).day())
    }

    func prepare() async {
        await requestCameraAccess()
        if cameraAccess == .granted {
            await camera.start(recordsAudio: await AVCaptureDevice.requestAccess(for: .audio))
        }
        await loadVenueImage()
    }

    func stopCamera() {
        camera.stop()
        videoPlayer?.pause()
    }

    // MARK: Shutter

    /// A tap takes a photo; holding past `holdToRecordDelay` records a video until release.
    func shutterPressed() {
        pressStartedRecording = false
        holdTask = Task {
            try? await Task.sleep(for: Self.holdToRecordDelay)
            guard !Task.isCancelled else { return }
            startRecording()
        }
    }

    func shutterReleased() {
        holdTask?.cancel()
        holdTask = nil
        if pressStartedRecording {
            stopRecording()
        } else {
            takePhoto()
        }
    }

    func takePhoto() {
        guard isCameraAvailable else {
            photoCaptured(Self.samplePhoto())
            return
        }
        Task {
            do {
                photoCaptured(try await camera.takePhoto())
            } catch {
                Logger.general.error("Error taking perk photo: \(error.localizedDescription)")
            }
        }
    }

    func startRecording() {
        pressStartedRecording = true
        isRecording = true
        // The Simulator only pretends to record; releasing makes a sample clip.
        guard isCameraAvailable else { return }
        Task {
            do {
                let clip = try await camera.recordVideo()
                await videoRecorded(clip)
            } catch {
                isRecording = false
                isPreparingVideo = false
            }
        }
    }

    func stopRecording() {
        // Already stopped when the clip hit the time limit.
        guard isRecording else { return }
        isRecording = false
        isPreparingVideo = true
        if isCameraAvailable {
            camera.stopRecording()
        } else {
            Task {
                do {
                    await videoRecorded(try await PerkShareVideo.sampleVideo(Self.sampleImage(width: 540, height: 960)))
                } catch {
                    isPreparingVideo = false
                }
            }
        }
    }

    /// Throws away the photo or video and goes back to the camera.
    func retake() {
        photo = nil
        shareImage = nil
        videoPlayer?.pause()
        videoPlayer = nil
        videoLooper = nil
        if let shareVideo {
            try? FileManager.default.removeItem(at: shareVideo)
        }
        shareVideo = nil
        guard cameraAccess == .granted else { return }
        Task {
            await camera.resume()
        }
    }

    func flipCamera() {
        usesFrontCamera.toggle()
        camera.useCamera(front: usesFrontCamera)
    }

    // MARK: Results

    func photoCaptured(_ image: UIImage) {
        photo = image
        camera.stop()
        renderShareImage()
    }

    private func videoRecorded(_ clip: URL) async {
        isRecording = false
        isPreparingVideo = true
        camera.stop()
        defer {
            isPreparingVideo = false
            try? FileManager.default.removeItem(at: clip)
        }
        let size = cardSizeOrDefault
        let overlay = ImageRenderer(content: PerkShareOverlayView(venueImage: venueImage, perkName: perk.perkName,
                                                                  dateText: dateText)
            .frame(width: size.width, height: size.height))
        // Any scale works; the export stretches the overlay to the video's size.
        overlay.scale = 3
        guard let overlayImage = overlay.uiImage else { return }
        do {
            let video = try await PerkShareVideo.export(clip, overlay: overlayImage, aspectRatio: size.width / size.height)
            let player = AVQueuePlayer()
            videoLooper = AVPlayerLooper(player: player, templateItem: AVPlayerItem(url: video))
            player.play()
            videoPlayer = player
            shareVideo = video
        } catch {
            Logger.general.error("Error preparing perk video: \(error.localizedDescription)")
        }
    }

    private var cardSizeOrDefault: CGSize {
        cardSize == .zero ? CGSize(width: 390, height: 700) : cardSize
    }

    private func renderShareImage() {
        guard let photo else { return }
        let size = cardSizeOrDefault
        let card = PerkShareCardView(photo: photo, venueImage: venueImage, perkName: perk.perkName, dateText: dateText)
            .frame(width: size.width, height: size.height)
        let renderer = ImageRenderer(content: card)
        // Fixed 3x keeps the shared image sharp on every device.
        renderer.scale = 3
        if let image = renderer.uiImage {
            shareImage = Image(uiImage: image)
        }
    }

    // MARK: Setup

    private func requestCameraAccess() async {
        guard isCameraAvailable else { return }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraAccess = .granted
        case .notDetermined:
            cameraAccess = await AVCaptureDevice.requestAccess(for: .video) ? .granted : .denied
        default:
            cameraAccess = .denied
        }
    }

    /// Loads the venue or event image as a UIImage, since ImageRenderer can't wait for an async image.
    /// Uses the same URLCache that CachedAsyncImage fills.
    private func loadVenueImage() async {
        guard let urlString = perk.imageUrl, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        if let cached = URLCache.shared.cachedResponse(for: request), let image = UIImage(data: cached.data) {
            venueImage = image
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
            venueImage = UIImage(data: data)
        } catch {
            Logger.network.error("Error loading perk share image: \(error.localizedDescription)")
        }
    }

    // MARK: Simulator stand-ins

    private static func samplePhoto() -> UIImage {
        let renderer = ImageRenderer(content: sampleGradient.frame(width: 1080, height: 1440))
        return renderer.uiImage ?? UIImage()
    }

    private static func sampleImage(width: CGFloat, height: CGFloat) -> CIImage {
        let renderer = ImageRenderer(content: sampleGradient.frame(width: width, height: height))
        return renderer.cgImage.map { CIImage(cgImage: $0) } ?? CIImage(color: .black)
    }

    private static var sampleGradient: some View {
        LinearGradient(colors: [.mainPurple, .onlineBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
