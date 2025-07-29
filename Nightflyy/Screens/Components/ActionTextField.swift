//
//  ActionTextField.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/9/25.
//

import SwiftUI

struct ActionTextField: View {
    let placeholder: String
    @Binding var value: String
    var disabled = false
    var isRequired: Bool = false
    var action: ButtonAction
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Text(placeholder)
                    .textCase(!value.isEmpty ? .uppercase : .none)
                    .foregroundStyle(.white.opacity(0.5))
                    .font(!value.isEmpty ? .system(size: 10) : .system(size: 14))
                    .offset(y: !value.isEmpty ? -20 : 0)
                    .overlay(alignment: .trailing, content: {
                        if isRequired {
                            Image(systemName: "asterisk")
                                .foregroundStyle(.white.opacity(0.5))
                                .font(.system(size: 10))
                                .offset(x: 20, y: !(value.isEmpty) ? -20 : 0)
                        }
                    })
                
                Text(value)
                    .lineLimit(1)
                    .frame(height: 55)
                    .disabled(disabled)
            }
            .layoutPriority(1)
            
            Spacer()
                .frame(height: 18)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 10))
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.white.opacity(0.5))
                .frame(height: 1)
                .offset(y: -10)
        })
        .onTapGesture {
            self.action()
        }
    }
}

#Preview {
    ActionTextField(placeholder: "First Name", value: .constant("Bernie"), action: {})
            .preferredColorScheme(.dark)
}
