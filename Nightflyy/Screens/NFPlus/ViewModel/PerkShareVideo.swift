//
//  PerkShareVideo.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/26.
//

import AVFoundation
import CoreImage
import UIKit

/// Turns a recorded clip into the shared perk video: cropped to the on-screen card and
/// with the perk branding drawn over every frame.
enum PerkShareVideo {

    /// Crops `video` around its center to `aspectRatio` (width / height), draws `overlay` over
    /// every frame, and writes an MP4 to a temporary file.
    static func export(_ video: URL, overlay: UIImage, aspectRatio: CGFloat) async throws -> URL {
        let asset = AVURLAsset(url: video)
        guard let track = try await asset.loadTracks(withMediaType: .video).first else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let (naturalSize, transform) = try await track.load(.naturalSize, .preferredTransform)
        let renderSize = renderSize(for: naturalSize.applying(transform), aspectRatio: aspectRatio)

        let overlayImage = CIImage(image: overlay).map { image in
            image.transformed(by: CGAffineTransform(scaleX: renderSize.width / image.extent.width,
                                                    y: renderSize.height / image.extent.height))
        }
        // Frames reach the handler already turned upright by the track's transform.
        let composition = try await AVMutableVideoComposition.videoComposition(with: asset) { request in
            let source = request.sourceImage
            let crop = CGRect(x: source.extent.midX - renderSize.width / 2,
                              y: source.extent.midY - renderSize.height / 2,
                              width: renderSize.width, height: renderSize.height)
            let frame = source.cropped(to: crop)
                .transformed(by: CGAffineTransform(translationX: -crop.minX, y: -crop.minY))
            request.finish(with: overlayImage?.composited(over: frame) ?? frame, context: nil)
        }
        composition.renderSize = renderSize

        guard let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            throw CocoaError(.featureUnsupported)
        }
        session.videoComposition = composition
        let output = URL.temporaryDirectory.appending(path: "\(UUID().uuidString).mp4")
        try await session.export(to: output, as: .mp4)
        return output
    }

    /// The largest centered crop of `size` with the given aspect ratio, in even pixels as the encoder needs.
    static func renderSize(for size: CGSize, aspectRatio: CGFloat) -> CGSize {
        let width = abs(size.width)
        let height = abs(size.height)
        let cropped = width / height > aspectRatio
            ? CGSize(width: height * aspectRatio, height: height)
            : CGSize(width: width, height: width / aspectRatio)
        return CGSize(width: (cropped.width / 2).rounded(.down) * 2, height: (cropped.height / 2).rounded(.down) * 2)
    }

    /// A short clip filled with `image`, standing in for the camera in the Simulator.
    /// `transform` is stored as the track's display transform, like the camera does for portrait video.
    static func sampleVideo(_ image: CIImage, frames: Int = 60,
                            transform: CGAffineTransform = .identity) async throws -> URL {
        let size = image.extent.size
        let url = URL.temporaryDirectory.appending(path: "\(UUID().uuidString).mov")
        let writer = try AVAssetWriter(outputURL: url, fileType: .mov)
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height
        ])
        input.transform = transform
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String: size.width,
            kCVPixelBufferHeightKey as String: size.height
        ])
        writer.add(input)
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)

        let context = CIContext()
        for frame in 0..<frames {
            while !input.isReadyForMoreMediaData {
                try await Task.sleep(for: .milliseconds(5))
            }
            guard let pool = adaptor.pixelBufferPool else { break }
            var buffer: CVPixelBuffer?
            CVPixelBufferPoolCreatePixelBuffer(nil, pool, &buffer)
            guard let buffer else { break }
            context.render(image, to: buffer)
            adaptor.append(buffer, withPresentationTime: CMTime(value: CMTimeValue(frame), timescale: 30))
        }
        input.markAsFinished()
        await writer.finishWriting()
        if let error = writer.error { throw error }
        return url
    }
}
