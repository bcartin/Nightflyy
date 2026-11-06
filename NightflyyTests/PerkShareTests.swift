//
//  PerkShareTests.swift
//  NightflyyTests
//

import CoreGraphics
import Foundation
import Testing
@testable import Nightflyy

@MainActor
struct PerkShareTests {

    @Test func cameraPreviewScalesUpAndCentersToFillTallerFrames() {
        // 300 wide gives a 400-tall 4:3 preview; filling 800 needs 2x, centered 200 down.
        let transform = CameraPreviewController.fillTransform(width: 300, containerHeight: 800)

        #expect(transform.a == 2)
        #expect(transform.d == 2)
        #expect(transform.ty == 200)
    }

    @Test func cameraPreviewIsNotShrunkInShorterFrames() {
        let transform = CameraPreviewController.fillTransform(width: 300, containerHeight: 300)

        #expect(transform.a == 1)
        #expect(transform.d == 1)
    }

    @Test func shareDateReadsLikeTheDesign() throws {
        let date = try #require(Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 2, hour: 12)))

        #expect(PerkShareViewModel.dateText(for: date, locale: Locale(identifier: "en_US")) == "Monday, Nov 2")
    }
}
