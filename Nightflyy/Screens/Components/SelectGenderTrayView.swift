//
//  SelectGenderTrayView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/9/25.
//

import SwiftUI

struct SelectGenderTrayView: View {
    
    @Binding var selectedGender: String
    @Binding var showSelectGenderView: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Select your gender")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
                Button {
                    showSelectGenderView = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.gray, .primary.opacity(0.1))
                }
            }
            
            ForEach(Gender.allCases, id: \.self) { gender in
                let isSelected: Bool = selectedGender == gender.rawValue
                HStack {
                    Text(gender.rawValue)
                        .fontWeight(.semibold)
                    
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
                            selectedGender = gender.rawValue
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SelectGenderTrayView(selectedGender: .constant("Male"), showSelectGenderView: .constant(true))
}
