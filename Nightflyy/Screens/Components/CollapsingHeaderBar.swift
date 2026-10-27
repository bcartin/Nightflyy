//
//  CollapsingHeaderBar.swift
//  Nightflyy
//

import SwiftUI

/// Top bar for scrolling detail screens (events, profiles).
///
/// Shows back and options buttons over the header image. As the image scrolls away,
/// the title slides in and the background turns solid. The enclosing scroll view must use
/// `.coordinateSpace(name: "SCROLL")`.
struct CollapsingHeaderBar: View {

    @Environment(Router.self) private var router

    let title: String
    let size: CGSize
    let safeArea: EdgeInsets
    var titleHorizontalPadding: CGFloat = 0
    var optionsLabel = "Options"
    var optionsImage = "ic_dotmenu"
    /// Called when the options button is tapped; `nil` hides the button.
    var onOptions: ButtonAction?

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProgress = minY / height

            HStack(spacing: 10) {
                if #available(iOS 26.0, *) { // TODO: Remove when min version is iOS 26
                    Button {
                        router.navigateBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .labelStyle(.iconOnly)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.white)
                    }
                    .glassEffect()
                } else {
                    Button {
                        router.navigateBack()
                    } label: {
                        HStack {
                            Spacer()
                                .frame(width: 12)
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundStyle(.white)
                            Spacer()
                                .frame(width: 48)
                        }
                    }
                }

                Spacer()

                if let onOptions {
                    if #available(iOS 26.0, *) { // TODO: Remove when min version is iOS 26
                        Button(action: onOptions) {
                            Label(optionsLabel, image: optionsImage)
                                .labelStyle(.iconOnly)
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.white)
                        }
                        .glassEffect()
                    } else {
                        Button(action: onOptions) {
                            Image(optionsImage)
                                .font(.title3)
                                .foregroundStyle(.white)
                                .tint(.white)
                        }
                    }
                }
            }
            .overlay {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .offset(y: -titleProgress > 0.75 ? 0 : 45)
                    .clipped()
                    .padding(.horizontal, titleHorizontalPadding)
                    .animation(.easeInOut(duration: 0.25), value: -titleProgress > 0.75)
            }
            .padding(.top, safeArea.top + 10)
            .padding([.horizontal, .bottom], 15)
            .background(
                .backgroundBlack
                    .opacity(-progress > 1 ? 1 : 0)
            )
            .offset(y: -minY)
        }
        .frame(height: 35)
    }
}
