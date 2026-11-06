//
//  PerkCameraPreview.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import SwiftUI

/// What sits behind the overlay before a photo is taken: the live camera, a prompt to allow
/// camera access, or a stand-in where there is no camera (the Simulator).
struct PerkCameraPreview: View {

    @Environment(\.openURL) private var openURL
    let viewModel: PerkShareViewModel

    var body: some View {
        if !viewModel.isCameraAvailable {
            LinearGradient(colors: [.mainPurple, .onlineBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay {
                    Text("No camera here. Tap the shutter to use a sample photo.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding()
                }
        } else {
            switch viewModel.cameraAccess {
            case .granted:
                CameraView(captureRequest: viewModel.captureRequest,
                           usesFrontCamera: viewModel.usesFrontCamera,
                           onCapture: viewModel.photoCaptured)
            case .denied:
                VStack {
                    Text("Allow camera access to take a photo of your perk.")
                        .multilineTextAlignment(.center)

                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            openURL(url)
                        }
                    }
                    .foregroundStyle(.mainPurple)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
            case .unknown:
                Color.black
            }
        }
    }
}
