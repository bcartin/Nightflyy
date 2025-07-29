//
//  TagSelectViewFull.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/7/25.
//

import SwiftUI

struct TagSelectViewFull: View {
    
    var title: String
    var tags: [String]
    @Binding var selectedTags: [String]
    
    var body: some View {
        VStack {
            ChipsView(tags: tags, selectedTags: $selectedTags) { tag, isSelected in
                    ChipView(tag: tag, isSelected: isSelected)
            } didChangeSelection: { selection in
                print(selection)
            }
            .padding(24)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    TagSelectViewFull(title: "Venues", tags: VenuesType.allValues, selectedTags: .constant([]))
}
