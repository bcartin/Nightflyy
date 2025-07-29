//
//  MainButton.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/24/24.
//

import SwiftUI

struct MainButton: ViewModifier {
    
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background{
                Capsule()
                    .fill(color.gradient)
            }
            .padding(.horizontal, 32)
    }
}

extension View {
    func mainButtonStyle(color: Color = .mainPurple) -> some View {
        modifier(MainButton(color: color))
    }
}
