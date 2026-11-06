//
//  PerkShareOverlayView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import SwiftUI

/// Branding drawn over the share photo: venue image, perk name, date and the Nightflyy logo.
/// Font sizes are fixed on purpose so the saved image looks the same whatever the user's text size.
struct PerkShareOverlayView: View {

    let venueImage: UIImage?
    let perkName: String
    let dateText: String

    var body: some View {
        VStack(spacing: 8) {
            Group {
                if let venueImage {
                    Image(uiImage: venueImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("venue_default")
                        .resizable()
                        .background(.white)
                }
            }
            .frame(width: 96, height: 96)
            .clipShape(.circle)

            Text(perkName.uppercased())
                .font(.custom("Bebas-Regular", fixedSize: 40))
                .multilineTextAlignment(.center)

            Text(dateText)
                .font(.custom("NeuropolXRg-Regular", fixedSize: 16))

            Spacer()

            Image("slyde_fly")
                .resizable()
                .scaledToFit()
                .frame(width: 144, height: 144)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.6), radius: 4)
        .allowsHitTesting(false)
    }
}
