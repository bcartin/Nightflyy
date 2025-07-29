//
//  View+Background.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

extension View {
    /// Applies a background image to the view, stretched to fill the entire background.
    /// - Parameter imageName: The name of the image asset to use as the background.
    /// - Returns: A view with the background image applied.
    func backgroundImage(_ imageName: String) -> some View {
        self.background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
    }
}
