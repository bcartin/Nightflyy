//
//  RedeemButtonView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct RedeemButtonView: View {
    
    @State private var glow = false
    @Binding var viewModel: NFPRedeemViewModel
    
    var body: some View {
        VStack(spacing: 36) {
            
            Text("Tap Below")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Button {
                viewModel.seeVenuesButtonIsVisible = false
                viewModel.changeView(to: .codeScreen)
            } label: {
                ZStack {
                    
                    Circle()
                        .fill(Color.onlineBlue)
                        .frame(width: 200, height: 200)
                        .shadow(color: Color.onlineBlue.opacity(glow ? 0.8 : 0.3), radius: glow ? 25 : 5)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                glow.toggle()
                            }
                        }
                    
                    Image("plus_button_borderless")
                        .resizable()
                        .frame(width: 200, height: 200)
                }
            }
            
            Text("Credits Remaining this week: 1")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        
    }
}

#Preview {
    MemberView()
}
