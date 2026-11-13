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

    /// Recording stops on its own after this long.
    static let maxRecordingSeconds: Double = 15

    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var videoInput: AVCaptureDeviceInput?
    private var photoContinuation: CheckedContinuation<UIImage, Error>?
    private var movieContinuation: CheckedContinuation<URL, Error>?

    /// Sets up the session on the rear camera, with sound when `recordsAudio`, and starts it.
    func start(recordsAudio: Bool) async {
        if videoInput == nil {
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
            useCamera(front: false)
        }
        await resume()
    }

    /// Restarts a stopped session with its current camera.
    func resume() async {
        // startRunning blocks until the camera is up, so keep it off the main thread.
        await Task.detached { [session] in session.startRunning() }.value
    }

    func stop() {
        Task.detached { [session] in session.stopRunning() }
    }

    func useCamera(front: Bool) {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: front ? .front : .back),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        session.beginConfiguration()
        if let videoInput {
            session.removeInput(videoInput)
        }
        if session.canAddInput(input) {
            session.addInput(input)
            videoInput = input
        } else if let videoInput {
            session.addInput(videoInput)
        }
        session.commitConfiguration()

        for output in [photoOutput, movieOutput] as [AVCaptureOutput] {
            guard let connection = output.connection(with: .video) else { continue }
            if connection.isVideoRotationAngleSupported(90) {
                connection.videoRotationAngle = 90
            }
            if connection.isVideoMirroringSupported {
                connection.automaticallyAdjustsVideoMirroring = false
                connection.isVideoMirrored = front
            }
        }
    }

    func takePhoto() async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            photoContinuation = continuation
            photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }

    /// Records until `stopRecording()` or the time limit, then returns the clip.
    func recordVideo() async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
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
