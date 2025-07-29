//
//  LongTextInputView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/10/25.
//

import SwiftUI

struct LongTextInputView: View {
    var title: String
    var prompt: String
    @Binding var text: String
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        VStack {
            
            TextField("", text: $text, prompt: Text(prompt).foregroundStyle(.white.opacity(0.5)), axis: .vertical)
                .font(.system(size: 14))
                .focused($isFieldFocused)
            
            Spacer()
            
        }
        .padding()
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
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .foregroundStyle(.mainPurple)
            }
        }
        .onAppear {
            isFieldFocused = true
        }
    }
}

#Preview {
    LongTextInputView(title: "Bio", prompt: "Type your bio", text: .constant(""))
}
