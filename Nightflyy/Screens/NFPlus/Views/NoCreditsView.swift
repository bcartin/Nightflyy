//
//  NoCreditsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct NoCreditsView: View {
    
    @Binding var viewModel: NFPRedeemViewModel
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 36) {
            Image("plus_button_bw")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("Redeem your next perk in:")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            HStack {
                Text(String(format: "%02d", viewModel.day))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                colon
                
                Text(String(format: "%02d", viewModel.hour))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                colon
                
                Text(String(format: "%02d", viewModel.minute))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                colon
                
                Text(String(format: "%02d", viewModel.second))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
        }
        .onReceive(timer) { _ in
            viewModel.updateTimer()
        }
    }
}

#Preview {
    MemberView()
}

extension NoCreditsView {
    private var colon: some View {
        Text(":")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
    }
}
