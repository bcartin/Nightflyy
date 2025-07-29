//
//  TagSelectView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

struct TagSelectView: View {
    
    var tags: [String]
    @Binding var selectedTags: [String]
    
    var body: some View {
        VStack {
            ChipsView(tags: tags, selectedTags: $selectedTags) { tag, isSelected in
                    ChipView(tag: tag, isSelected: isSelected)
            } didChangeSelection: { selection in
                print(selection)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 4)
            
            Spacer()
        }
        
    }
    
   
}

#Preview {
    @Previewable @State var tags: [String] = []
    TagSelectView(tags: MusicGenre.allValues, selectedTags: $tags)
}
