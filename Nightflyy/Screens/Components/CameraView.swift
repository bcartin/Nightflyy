//
//  CameraView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import AVFoundation
import SwiftUI

/// Live preview of a capture session, filling its frame and cropping like the captured photo
/// and video. SwiftUI has no camera preview, so this wraps the preview layer.
struct CameraView: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ view: PreviewView, context: Context) {}

    final class PreviewView: UIView {

        override static var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

        // layerClass guarantees the layer type.
        // swiftlint:disable:next force_cast
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}
