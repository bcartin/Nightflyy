//
//  CameraView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import SwiftUI
import UIKit

/// Live rear-camera preview that fills its frame. Increase `captureRequest` to take a photo;
/// the photo arrives through `onCapture`.
struct CameraView: UIViewControllerRepresentable {

    let captureRequest: Int
    let onCapture: (UIImage) -> Void

    func makeUIViewController(context: Context) -> CameraPreviewController {
        let controller = CameraPreviewController()
        controller.picker.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: CameraPreviewController, context: Context) {
        context.coordinator.onCapture = onCapture
        if captureRequest != context.coordinator.lastCaptureRequest {
            context.coordinator.lastCaptureRequest = captureRequest
            controller.picker.takePicture()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(captureRequest: captureRequest, onCapture: onCapture)
    }

    @MainActor
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var lastCaptureRequest: Int
        var onCapture: (UIImage) -> Void

        init(captureRequest: Int, onCapture: @escaping (UIImage) -> Void) {
            self.lastCaptureRequest = captureRequest
            self.onCapture = onCapture
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                onCapture(image)
            }
        }
    }
}
