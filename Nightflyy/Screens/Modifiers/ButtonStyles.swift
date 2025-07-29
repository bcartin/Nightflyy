//
//  ButtonStyles.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/11/25.
//

import Foundation
import SwiftUI

enum ActionButtonStyle {

    case actionPrimary
    case actionSecondary
    
    var backgroundColor: Color {
        switch self {
        case .actionPrimary:
                .mainPurple
        case .actionSecondary:
                .backgroundBlack
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .actionPrimary:
                .white
        case .actionSecondary:
                .mainPurple
        }
    }
    
    var borderColor: Color {
        switch self {
        case .actionPrimary:
                .clear
        case .actionSecondary:
                .mainPurple
        }
    }
    
}

struct CustomButtonStyle: ButtonStyle {
    var style: ActionButtonStyle

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundStyle(style.foregroundColor)
            .frame(width: 125, height: 32)
            .background(style.backgroundColor)
            .clipShape(Capsule())
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(style.borderColor)
            }
    }
}

extension ButtonStyle where Self == CustomButtonStyle {
    static var actionPrimary: CustomButtonStyle {
        CustomButtonStyle(style: .actionPrimary)
    }

    static var actionSecondary: CustomButtonStyle {
        CustomButtonStyle(style: .actionSecondary)
    }

}
