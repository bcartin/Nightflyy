//
//  PerkShareViewModel.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import AVFoundation
import OSLog
import SwiftUI

/// Drives the perk share camera: camera permission, the captured photo, and the branded image to share.
@Observable @MainActor
final class PerkShareViewModel {

    enum CameraAccess {
        case unknown
        case granted
        case denied
    }

    let perk: NFPPerk
    let dateText: String
    /// False in the Simulator, which has no camera; the shutter then uses a sample photo.
    let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)

    var cameraAccess: CameraAccess = .unknown
    var venueImage: UIImage?
    var photo: UIImage?
    /// The photo with the branding drawn on, ready for the share sheet.
    var shareImage: Image?
    /// Increased to ask `CameraView` to take a photo.
    var captureRequest = 0
    /// Size of the on-screen card, so the shared image matches what the user saw.
    var cardSize: CGSize = .zero

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
        await loadVenueImage()
    }

    func takePhoto() {
        if isCameraAvailable {
            captureRequest += 1
        } else {
            photoCaptured(Self.samplePhoto())
        }
    }

    func photoCaptured(_ image: UIImage) {
        photo = image
        renderShareImage()
    }

    private func renderShareImage() {
        guard let photo else { return }
        let size = cardSize == .zero ? CGSize(width: 390, height: 700) : cardSize
        let card = PerkShareCardView(photo: photo, venueImage: venueImage, perkName: perk.perkName, dateText: dateText)
            .frame(width: size.width, height: size.height)
        let renderer = ImageRenderer(content: card)
        // Fixed 3x keeps the shared image sharp on every device.
        renderer.scale = 3
        if let image = renderer.uiImage {
            shareImage = Image(uiImage: image)
        }
    }

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

    /// Stand-in photo for the Simulator.
    private static func samplePhoto() -> UIImage {
        let gradient = LinearGradient(colors: [.mainPurple, .onlineBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 1080, height: 1440)
        return ImageRenderer(content: gradient).uiImage ?? UIImage()
    }
}
