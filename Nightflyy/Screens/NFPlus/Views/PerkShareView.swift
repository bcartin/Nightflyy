//
//  PerkShareView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import SwiftUI

/// Camera screen for sharing a redeemed perk: tap for a photo or hold for a video under the perk
/// branding, then share or save it through the share sheet (which includes Save Image and Save Video), or cancel.
struct PerkShareView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PerkShareViewModel

    init(perk: NFPPerk) {
        _viewModel = State(initialValue: PerkShareViewModel(perk: perk))
    }

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if let photo = viewModel.photo {
                    PerkShareCardView(photo: photo,
                                      venueImage: viewModel.venueImage,
                                      perkName: viewModel.perk.perkName,
                                      dateText: viewModel.dateText)
                } else if let player = viewModel.videoPlayer {
                    // The video already has the branding burned in.
                    PlayerLayerView(player: player)
                } else if viewModel.isPreparingVideo {
                    Color.black
                        .overlay {
                            ProgressView("Preparing video…")
                                .tint(.white)
                        }
                } else {
                    PerkCameraPreview(viewModel: viewModel)

                    PerkShareOverlayView(venueImage: viewModel.venueImage,
                                         perkName: viewModel.perk.perkName,
                                         dateText: viewModel.dateText)

                    PerkShutterButton(isRecording: viewModel.isRecording,
                                      onPress: viewModel.shutterPressed,
                                      onRelease: viewModel.shutterReleased)
                    .allowsHitTesting(!viewModel.isCameraAvailable || viewModel.cameraAccess == .granted)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        if viewModel.canFlipCamera && viewModel.cameraAccess == .granted && !viewModel.isRecording {
                            Button("Flip Camera", systemImage: "arrow.triangle.2.circlepath", action: viewModel.flipCamera)
                                .labelStyle(.iconOnly)
                                .font(.title2)
                                .frame(width: 52, height: 52)
                                .background(.ultraThinMaterial, in: .circle)
                                .padding(.leading, 32)
                        }
                    }
                    .padding(.bottom, 24)
                }

                if viewModel.hasResult {
                    Button("Retake", systemImage: "arrow.counterclockwise", action: viewModel.retake)
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: .capsule)
                        .padding(.bottom, 24)
                }
            }
            .clipShape(.rect(cornerRadius: 24))
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { size in
                viewModel.cardSize = size
            }

            HStack {
                if let shareVideo = viewModel.shareVideo {
                    ShareLink(item: shareVideo, preview: SharePreview(viewModel.perk.perkName)) {
                        Text("Share")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else if let shareImage = viewModel.shareImage {
                    ShareLink(item: shareImage, preview: SharePreview(viewModel.perk.perkName, image: shareImage)) {
                        Text("Share")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button {} label: {
                        Text("Share")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(true)
                }

                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.white)
            }
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .tint(.mainPurple)
        }
        .padding()
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .task {
            await viewModel.prepare()
        }
        .onDisappear(perform: viewModel.stopCamera)
    }
}
