//
//  AnimatedGIFView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/26.
//

import ImageIO
import SwiftUI

/// Plays a GIF from a data asset in the asset catalog, scaled to fit, with each frame's own timing.
/// SwiftUI's Image only shows a GIF's first frame.
struct AnimatedGIFView: UIViewRepresentable {

    let assetName: String

    func makeUIView(context: Context) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        guard let data = NSDataAsset(name: assetName)?.data else { return view }
        // Show the first frame right away so the view can size itself before playback starts.
        if let source = CGImageSourceCreateWithData(data as CFData, nil),
           let firstFrame = CGImageSourceCreateImageAtIndex(source, 0, nil) {
            view.image = UIImage(cgImage: firstFrame)
        }
        // Frames arrive on the main queue; playback stops once the view is gone.
        CGAnimateImageDataWithBlock(data as CFData, nil) { [weak view] _, frame, stop in
            guard let view else {
                stop.pointee = true
                return
            }
            view.image = UIImage(cgImage: frame)
        }
        return view
    }

    func updateUIView(_ view: UIImageView, context: Context) {}

    /// Fits the GIF inside the offered space, keeping its shape.
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIImageView, context: Context) -> CGSize? {
        guard let imageSize = uiView.image?.size, imageSize.width > 0, imageSize.height > 0 else { return nil }
        let scales = [proposal.width.map { $0 / imageSize.width },
                      proposal.height.map { $0 / imageSize.height }]
            .compactMap { $0 }
            .filter(\.isFinite)
        let scale = scales.min() ?? 1
        return CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
    }
}
