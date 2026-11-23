//
//  CameraController.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/26.
//

import AVFoundation
import OSLog
import UIKit

/// Portrait photo and video capture from one capture session, so switching between a photo and a
/// video has no delay. Photos and videos from the front camera are mirrored to match its preview.
@MainActor
final class CameraController: NSObject {

    enum CameraError: Error {
        /// The camera isn't running, or is still busy with the last photo or video.
        case notReady
    }

    /// Recording stops on its own after this long.
    nonisolated static let maxRecordingSeconds: Double = 15

    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var isConfigured = false
    private var lastSessionJob: Task<Void, Never>?
    private var photoContinuation: CheckedContinuation<UIImage, Error>?
    private var movieContinuation: CheckedContinuation<URL, Error>?

    /// Sets up the session on the rear camera, with sound when `recordsAudio`, and starts it.
    func start(recordsAudio: Bool) async {
        if !isConfigured {
            isConfigured = true
            let session = session
            let photoOutput = photoOutput
            let movieOutput = movieOutput
            await runSessionJob {
                session.beginConfiguration()
                // Photos come out at video resolution, which keeps both outputs on one session.
                session.sessionPreset = .high
                if recordsAudio, let microphone = AVCaptureDevice.default(for: .audio),
                   let input = try? AVCaptureDeviceInput(device: microphone), session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(photoOutput) {
                    session.addOutput(photoOutput)
                }
                if session.canAddOutput(movieOutput) {
                    session.addOutput(movieOutput)
                    movieOutput.maxRecordedDuration = CMTime(seconds: Self.maxRecordingSeconds, preferredTimescale: 600)
                }
                session.commitConfiguration()
            }.value
            await useCamera(front: false)
        }
        await resume()
    }

    /// Restarts a stopped session with its current camera.
    func resume() async {
        await runSessionJob { [session] in session.startRunning() }.value
    }

    func stop() {
        runSessionJob { [session] in session.stopRunning() }
    }

    func useCamera(front: Bool) async {
        let session = session
        let outputs: [AVCaptureOutput] = [photoOutput, movieOutput]
        await runSessionJob {
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: front ? .front : .back),
                  let input = try? AVCaptureDeviceInput(device: device) else { return }
            let currentInputs = session.inputs
                .compactMap { $0 as? AVCaptureDeviceInput }
                .filter { $0.device.hasMediaType(.video) }
            session.beginConfiguration()
            currentInputs.forEach(session.removeInput)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                currentInputs.forEach(session.addInput)
            }
            session.commitConfiguration()

            for output in outputs {
                guard let connection = output.connection(with: .video) else { continue }
                if connection.isVideoRotationAngleSupported(90) {
                    connection.videoRotationAngle = 90
                }
                if connection.isVideoMirroringSupported {
                    connection.automaticallyAdjustsVideoMirroring = false
                    connection.isVideoMirrored = front
                }
            }
        }.value
    }

    /// Runs session work off the main thread, one job at a time, in the order it was asked for.
    /// Starting, stopping or reconfiguring a session while another of these is in progress throws an
    /// exception that crashes the app. Jobs block a background thread while the camera starts or stops.
    @discardableResult
    private func runSessionJob(_ job: @escaping @Sendable () -> Void) -> Task<Void, Never> {
        let previousJob = lastSessionJob
        let task = Task.detached {
            await previousJob?.value
            job()
        }
        lastSessionJob = task
        return task
    }

    /// Whether `output` can capture right now. Capturing without a running camera throws an
    /// exception that crashes the app, for example right after opening or during a phone call.
    private func canCapture(with output: AVCaptureOutput) -> Bool {
        guard session.isRunning, !session.isInterrupted,
              let connection = output.connection(with: .video) else { return false }
        return connection.isEnabled && connection.isActive
    }

    func takePhoto() async throws -> UIImage {
        // A second capture before the first finishes would replace, and so strand, its continuation.
        guard photoContinuation == nil, canCapture(with: photoOutput) else { throw CameraError.notReady }
        return try await withCheckedThrowingContinuation { continuation in
            photoContinuation = continuation
            photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }

    /// Records until `stopRecording()` or the time limit, then returns the clip.
    func recordVideo() async throws -> URL {
        guard movieContinuation == nil, canCapture(with: movieOutput) else { throw CameraError.notReady }
        return try await withCheckedThrowingContinuation { continuation in
            movieContinuation = continuation
            let url = URL.temporaryDirectory.appending(path: "\(UUID().uuidString).mov")
            movieOutput.startRecording(to: url, recordingDelegate: self)
        }
    }

    func stopRecording() {
        movieOutput.stopRecording()
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {

    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let data = photo.fileDataRepresentation()
        Task { @MainActor in
            if let data, let image = UIImage(data: data) {
                photoContinuation?.resume(returning: image)
            } else {
                photoContinuation?.resume(throwing: error ?? CocoaError(.fileReadCorruptFile))
            }
            photoContinuation = nil
        }
    }
}

extension CameraController: AVCaptureFileOutputRecordingDelegate {

    nonisolated func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL,
                                from connections: [AVCaptureConnection], error: Error?) {
        // Hitting the time limit reports an error even though the clip is fine.
        let isComplete = error == nil
            || (error as NSError?)?.userInfo[AVErrorRecordingSuccessfullyFinishedKey] as? Bool == true
        Task { @MainActor in
            if isComplete {
                movieContinuation?.resume(returning: outputFileURL)
            } else {
                Logger.general.error("Error recording perk video: \(error?.localizedDescription ?? "")")
                movieContinuation?.resume(throwing: error ?? CocoaError(.fileWriteUnknown))
            }
            movieContinuation = nil
        }
    }
}
