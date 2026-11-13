//
//  PerkShutterButton.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/13/26.
//

import SwiftUI

/// Shutter for the share camera. It reports press and release so the view model can tell a tap
/// (photo) from a hold (video). While recording it turns red and a ring fills over the time limit.
struct PerkShutterButton: View {

    let isRecording: Bool
    let onPress: () -> Void
    let onRelease: () -> Void

    @State private var isPressing = false
    @State private var recordingProgress = 0.0

    var body: some View {
        Circle()
            .fill(isRecording ? .red : .white)
            .frame(width: 64, height: 64)
            .padding(4)
            .overlay {
                Circle()
                    .stroke(.white.opacity(0.6), lineWidth: 3)
            }
            .overlay {
                Circle()
                    .trim(from: 0, to: recordingProgress)
                    .stroke(.red, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .scaleEffect(isRecording ? 1.2 : 1)
            .animation(.smooth, value: isRecording)
            .contentShape(.circle)
            // A Button can't report a hold, so a zero-distance drag tracks press and release.
            // Its callbacks fire even for a tap that starts and ends in the same frame.
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    guard !isPressing else { return }
                    isPressing = true
                    onPress()
                }
                .onEnded { _ in
                    isPressing = false
                    onRelease()
                })
            .onChange(of: isRecording) { _, isRecording in
                if isRecording {
                    withAnimation(.linear(duration: CameraController.maxRecordingSeconds)) {
                        recordingProgress = 1
                    }
                } else {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        recordingProgress = 0
                    }
                }
            }
            .accessibilityElement()
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(isRecording ? "Stop Recording" : "Take Photo")
            .accessibilityHint("Hold to record a video.")
            .accessibilityAction {
                onPress()
                onRelease()
            }
    }
}
