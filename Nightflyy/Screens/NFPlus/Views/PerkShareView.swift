//
//  PerkShareView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import SwiftUI

/// Camera screen for sharing a redeemed perk: take a photo under the perk branding, then share or
/// save it through the share sheet (which includes Save Image), or cancel.
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
                } else {
                    PerkCameraPreview(viewModel: viewModel)

                    PerkShareOverlayView(venueImage: viewModel.venueImage,
                                         perkName: viewModel.perk.perkName,
                                         dateText: viewModel.dateText)

                    Button(action: viewModel.takePhoto) {
                        Circle()
                            .fill(.white)
                            .frame(width: 64, height: 64)
                            .padding(4)
                            .overlay {
                                Circle()
                                    .stroke(.white.opacity(0.6), lineWidth: 3)
                            }
                    }
                    .accessibilityLabel("Take Photo")
                    .disabled(viewModel.isCameraAvailable && viewModel.cameraAccess != .granted)
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
                if let shareImage = viewModel.shareImage {
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
    }
}
