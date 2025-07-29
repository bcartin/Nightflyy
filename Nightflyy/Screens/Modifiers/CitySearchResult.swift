//
//  CitySearchResult.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI

struct CitySearchResult: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 1)
            }
    }
}

extension View {
    func citySearchResult() -> some View {
        modifier(CitySearchResult())
    }
}
