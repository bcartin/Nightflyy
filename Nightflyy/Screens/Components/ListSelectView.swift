//
//  ListSelectView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/9/25.
//

import SwiftUI

struct ListSelectView: View {
    
    var title: String
    var listItems: [String]
    @Binding var selectedItem: String
    
    var body: some View {
        VStack {
            ForEach(listItems, id: \.self) { item in
                let isSelected: Bool = selectedItem == item
                HStack {
                    Text(item)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle.fill")
                        .font(.title)
                        .contentTransition(.symbolEffect)
                        .foregroundStyle(isSelected ? Color.mainPurple : Color.gray.opacity(0.2))
                }
                .padding(.vertical, 6)
                .contentShape(.rect)
                .onTapGesture {
                    if !isSelected {
                        withAnimation(.snappy) {
                            selectedItem = item
                        }
                    }
                }
            }
            
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
//    ListSelectView(listItems: Gender.allCases.map(\.rawValue), selectedItem: .constant("Male"))
}
