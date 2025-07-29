//
//  IconButton.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/11/24.
//

import SwiftUI

struct IconButton: View {
    
    var iconName: String
    var title: String
    var isEnabled: Bool = true
    var color: Color?
    var action: ButtonAction
    
    var body: some View {
        Button {
            self.action()
        } label: {
            VStack(alignment: .center, spacing: 0) {
                Image(iconName)
                    .resizable()
                    .frame(width: 38, height: 38)
                
                Text(title)
                    .font(.system(size: 12))
            }
            .foregroundStyle(color != nil ? color ?? .white : Color.white.opacity(isEnabled ? 1 : 0.3))
        }
        .disabled(!isEnabled)

    }
}

#Preview {
    IconButton(iconName: "ic_share", title: "Share", action: {})
        .preferredColorScheme(.dark)
}
