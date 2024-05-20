//
//  SearchListFilterButtonView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/7/24.
//

import SwiftUI

struct SearchListFilterButtonView: View {
    
    var value: String
    @Binding var selectedValues: [String]
    
    var isSelected: Bool {
        selectedValues.contains(value)
    }
    
    var body: some View {
        HStack {
            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.medium)
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .foregroundStyle(.mainPurple)
                .font(.title)
                .onTapGesture {
                    if isSelected {
                        selectedValues.removeAll{$0 == value}
                    }
                    else {
                        selectedValues.append(value)
                    }
                }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SearchListFilterButtonView(value: "Lounge", selectedValues: .constant(.init()))
        .preferredColorScheme(.dark)
}
