//
//  CreditRedeemedView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct CreditRedeemedView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image("ConfirmationCheck")
                .resizable()
                .frame(width: 96, height: 96)
            
            Text("Credit Redeemed")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
            
            Text("Enjoy your perk!")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
            
            Button {
                
            } label: {
                Text("Continue")
            }
            .mainButtonStyle()

            
            Text("*Remember to tip your server generously*")
                .font(.system(size: 10))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    MemberView()
}
