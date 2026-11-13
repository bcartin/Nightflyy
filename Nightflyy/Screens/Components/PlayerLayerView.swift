//
//  PlayerLayerView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/26.
//

import AVFoundation
import SwiftUI

/// Shows a player's video filling its frame, with no playback controls.
/// SwiftUI's VideoPlayer always brings its own controls and hides the status bar.
struct PlayerLayerView: UIViewRepresentable {

    let player: AVPlayer

    func makeUIView(context: Context) -> LayerView {
        let view = LayerView()
        view.playerLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ view: LayerView, context: Context) {
        view.playerLayer.player = player
    }

    final class LayerView: UIView {

        override static var layerClass: AnyClass { AVPlayerLayer.self }

        // layerClass guarantees the layer type.
        // swiftlint:disable:next force_cast
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    }
}
