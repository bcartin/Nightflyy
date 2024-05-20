//
//  RedeemCodeView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct RedeemCodeView: View {
    
    @State var code: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image("plus_button_borderless")
                .resizable()
                .frame(width: 96, height: 96)
            
            Text("Present this screen to\nyour server")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            TextField("", text: $code, prompt: Text("0000"))
                .font(.system(size: 124, weight: .medium))
                .focused($isFocused)
                .frame(width: 315)
                .keyboardType(.numberPad)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 315, height: 4)
                }
            
            Button {
                
            } label: {
                Text("Redeem")
            }
            .mainButtonStyle()
            .padding(.top, 16)
            
            Button {
                
            } label: {
                Text("Cancel")
            }
            .mainButtonStyle(color: .gray)

        }
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    MemberView()
}
