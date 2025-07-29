//
//  View+HideNavbarBackground.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 1/30/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hideNavbarBackground() -> some View {
        self.toolbarBackgroundVisibility(.hidden, for: .navigationBar)
    }
}
