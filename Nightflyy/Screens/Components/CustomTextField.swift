//
//  CustomTextField.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 12/4/24.
//

import SwiftUI
import Combine

struct CustomTextField: View {
    let placeholder: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .default
    @State private var isTyping: Bool = false
    @FocusState var isFocused: Bool
    var disabled = false
    var isRequired: Bool = false
    @State var showIsMissing: Bool = false

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if showIsMissing {
                    Rectangle()
                        .fill(Color.red.opacity(0.2))
                        .frame(height: 36)
                }
                
                Text(placeholder)
                    .textCase(isTyping || !(value.isEmpty) ? .uppercase : .none)
                    .foregroundStyle(isTyping ? .mainPurple : .white.opacity(0.5))
                    .font(isTyping || !(value.isEmpty) ? .system(size: 10) : .system(size: 14))
                    .offset(y: isTyping || !(value.isEmpty) ? -20 : 0)
                    .overlay(alignment: .trailing, content: {
                        if isRequired {
                            Image(systemName: "asterisk")
                                .foregroundStyle(showIsMissing ? .red : .white.opacity(0.5))
                                .font(.system(size: 10))
                                .offset(x: 20, y: isTyping || !(value.isEmpty) ? -20 : 0)
                        }
                    })
                
                
                    TextField("", text: $value)
                        .frame(height: 55)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .disabled(disabled)
            }
            .overlay(alignment: .bottom, content: {
                Rectangle()
                    .fill(isTyping ? .mainPurple : .white.opacity(0.5))
                    .frame(height: 1)
                    .offset(y: -10)
            })
            
            .onChange(of: isFocused) { oldValue, newValue in
                withAnimation {
                    isTyping = newValue
                }
                if value.isEmpty && isRequired {
                    showIsMissing = !newValue
                }
            }
        }
    }
}

#Preview {
    VStack {
        CustomTextField(placeholder: "First Name", value: .constant(""), isRequired: true)
            .preferredColorScheme(.dark)
        
        CustomTextField(placeholder: "Last Name", value: .constant(""))
            .preferredColorScheme(.dark)
    }
}
