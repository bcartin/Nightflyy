//
//  CameraView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import SwiftUI
import UIKit

/// Live camera preview that fills its frame. Increase `captureRequest` to take a photo;
/// the photo arrives through `onCapture`.
struct CameraView: UIViewControllerRepresentable {

    let captureRequest: Int
    var usesFrontCamera = false
    let onCapture: (UIImage) -> Void

    func makeUIViewController(context: Context) -> CameraPreviewController {
        let controller = CameraPreviewController()
        controller.picker.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: CameraPreviewController, context: Context) {
        context.coordinator.onCapture = onCapture
        let device: UIImagePickerController.CameraDevice = usesFrontCamera ? .front : .rear
        if controller.picker.cameraDevice != device {
            controller.picker.cameraDevice = device
            // Switching cameras can reset the preview transform, so lay out again to reapply it.
            controller.view.setNeedsLayout()
        }
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
