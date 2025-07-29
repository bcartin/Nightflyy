//
//  ChipView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

struct ChipView: View {
    
    var tag: String
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Text(tag)
                .font(.system(size: 16))
                .foregroundStyle(.white)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            ZStack {
                Capsule()
                    .fill(.gray.opacity(0.2))
                    .opacity(!isSelected ? 1 : 0)
                
                Capsule()
                    .fill(.mainPurple.gradient)
                    .opacity(isSelected ? 1 : 0)
            }
        }
    }
}

#Preview {
    ChipView(tag: "Latin", isSelected: false)
        .preferredColorScheme(.dark)
}
