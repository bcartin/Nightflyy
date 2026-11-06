//
//  PerkShareCardView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/26.
//

import SwiftUI

/// A captured photo with the perk branding on top. Shown after capture and rendered into the shared image.
struct PerkShareCardView: View {

    let photo: UIImage
    let venueImage: UIImage?
    let perkName: String
    let dateText: String

    var body: some View {
        // Color.clear sets the size; the photo fills it and is cropped, like the live preview.
        Color.clear
            .overlay {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .overlay {
                PerkShareOverlayView(venueImage: venueImage, perkName: perkName, dateText: dateText)
            }
    }
}
