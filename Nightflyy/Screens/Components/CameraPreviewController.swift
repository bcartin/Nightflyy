//
//  CameraPreviewController.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import UIKit

/// Hosts a control-less rear camera that fills this controller's view.
/// SwiftUI has no camera view, so `CameraView` wraps this.
final class CameraPreviewController: UIViewController {

    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Callers must check UIImagePickerController.isSourceTypeAvailable(.camera) first.
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        picker.showsCameraControls = false
        addChild(picker)
        view.addSubview(picker.view)
        picker.didMove(toParent: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        picker.view.frame = view.bounds
        picker.cameraViewTransform = Self.fillTransform(width: view.bounds.width, containerHeight: view.bounds.height)
    }

    /// Without its controls, the picker shows a 4:3 preview pinned to the top. This centers it
    /// and scales it up so it fills a taller container, matching an aspect-fill crop of the photo.
    static func fillTransform(width: CGFloat, containerHeight: CGFloat) -> CGAffineTransform {
        let previewHeight = width * 4 / 3
        guard previewHeight > 0 else { return .identity }
        let scale = max(1, containerHeight / previewHeight)
        return CGAffineTransform(translationX: 0, y: (containerHeight - previewHeight) / 2)
            .scaledBy(x: scale, y: scale)
    }
}
