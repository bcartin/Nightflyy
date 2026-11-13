//
//  PerkShareTests.swift
//  NightflyyTests
//

import AVFoundation
import CoreImage
import SwiftUI
import Testing
@testable import Nightflyy

@MainActor
struct PerkShareTests {

    @Test func shareDateReadsLikeTheDesign() throws {
        let date = try #require(Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 2, hour: 12)))

        #expect(PerkShareViewModel.dateText(for: date, locale: Locale(identifier: "en_US")) == "Monday, Nov 2")
    }

    // The Simulator has no camera, so these use the sample photo and video.
    @Test func tappingTheShutterTakesAPhoto() {
        let viewModel = PerkShareViewModel(perk: Self.perk)

        viewModel.shutterPressed()
        viewModel.shutterReleased()

        #expect(viewModel.photo != nil)
        #expect(viewModel.shareImage != nil)
        #expect(!viewModel.isRecording)
    }

    @Test func retakeGoesBackToTheCamera() async throws {
        let viewModel = PerkShareViewModel(perk: Self.perk)
        viewModel.shutterPressed()
        try await Task.sleep(for: PerkShareViewModel.holdToRecordDelay * 2)
        viewModel.shutterReleased()
        while viewModel.isPreparingVideo {
            try await Task.sleep(for: .milliseconds(50))
        }
        let video = try #require(viewModel.shareVideo)
        #expect(viewModel.hasResult)

        viewModel.retake()

        #expect(!viewModel.hasResult)
        #expect(viewModel.shareVideo == nil)
        #expect(viewModel.shareImage == nil)
        #expect(!FileManager.default.fileExists(atPath: video.path()))
    }

    @Test func holdingTheShutterRecordsABrandedVideo() async throws {
        let viewModel = PerkShareViewModel(perk: Self.perk)

        viewModel.shutterPressed()
        try await Task.sleep(for: PerkShareViewModel.holdToRecordDelay * 2)
        #expect(viewModel.isRecording)

        viewModel.shutterReleased()
        while viewModel.isRecording || viewModel.isPreparingVideo {
            try await Task.sleep(for: .milliseconds(50))
        }

        #expect(viewModel.photo == nil)
        #expect(viewModel.shareVideo != nil)
    }

    private static let perk = NFPPerk(event: Event())

    @Test func renderSizeCropsWiderVideoToTheCardShape() {
        #expect(PerkShareVideo.renderSize(for: CGSize(width: 1080, height: 1920), aspectRatio: 0.5) == CGSize(width: 960, height: 1920))
    }

    @Test func renderSizeCropsTallerVideoAndKeepsEvenPixels() {
        #expect(PerkShareVideo.renderSize(for: CGSize(width: 1080, height: 1920), aspectRatio: 0.6) == CGSize(width: 1080, height: 1800))
    }

    /// Records a landscape clip with a portrait display transform, as the camera does, and checks the
    /// export is upright, cropped to the card and has the overlay in the right corner.
    @Test func exportedVideoIsUprightCroppedAndBranded() async throws {
        // Natural frame: left half red, right half blue. Turned upright, red is on top.
        let frame = CIImage(color: .red).cropped(to: CGRect(x: 0, y: 0, width: 80, height: 90))
            .composited(over: CIImage(color: .blue).cropped(to: CGRect(x: 0, y: 0, width: 160, height: 90)))
        let portrait = CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 90, ty: 0)
        let source = try await PerkShareVideo.sampleVideo(frame, frames: 10, transform: portrait)

        // A green square in the bottom-right corner of an 80x160 overlay.
        let renderer = ImageRenderer(content: Color.clear
            .frame(width: 40, height: 80)
            .overlay(alignment: .bottomTrailing) { Color.green.frame(width: 10, height: 10) })
        renderer.scale = 2
        let overlay = try #require(renderer.uiImage)

        let output = try await PerkShareVideo.export(source, overlay: overlay, aspectRatio: 0.5)

        let generator = AVAssetImageGenerator(asset: AVURLAsset(url: output))
        generator.appliesPreferredTrackTransform = true
        let image = try await generator.image(at: .zero).image
        #expect(image.width == 80)
        #expect(image.height == 160)

        let pixels = try #require(Pixels(image))
        #expect(pixels.dominantChannel(column: 40, row: 30) == .red)
        #expect(pixels.dominantChannel(column: 40, row: 120) == .blue)
        #expect(pixels.dominantChannel(column: 74, row: 154) == .green)
    }
}

/// RGBA pixels of an image, top row first.
private struct Pixels {

    enum Channel { case red, green, blue }

    let width: Int
    let data: [UInt8]

    init?(_ image: CGImage) {
        width = image.width
        var data = [UInt8](repeating: 0, count: image.width * image.height * 4)
        let drawn = data.withUnsafeMutableBytes { buffer in
            guard let context = CGContext(data: buffer.baseAddress, width: image.width, height: image.height,
                                          bitsPerComponent: 8, bytesPerRow: image.width * 4,
                                          space: CGColorSpaceCreateDeviceRGB(),
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return false }
            context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
            return true
        }
        guard drawn else { return nil }
        self.data = data
    }

    func dominantChannel(column: Int, row: Int) -> Channel {
        let index = (row * width + column) * 4
        let red = data[index], green = data[index + 1], blue = data[index + 2]
        if red > green && red > blue { return .red }
        return green > blue ? .green : .blue
    }
}
