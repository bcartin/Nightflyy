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
        VStack(spacing: 24) {
            
            Spacer()
                .frame(height: 150)
            
            Image("plus_button_bw")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("Redeem your next perk in:")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            HStack(alignment: .bottom) {
                VStack(spacing: 8) {
                    Text("D")
                    
                    Text(String(format: "%02d", viewModel.day))
                }
                
                colon
                
                VStack(spacing: 8) {
                    Text("H")
                    
                    Text(String(format: "%02d", viewModel.hour))
                }
                
                colon
                
                VStack(spacing: 8) {
                    Text("M")
                    
                    Text(String(format: "%02d", viewModel.minute))
                }
                
                colon
                
                VStack(spacing: 8) {
                    Text("S")
                    
                    Text(String(format: "%02d", viewModel.second))
                }
            }
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white)
            
            Spacer()
            
//            Button("See All Nightflyy+ Venues") {
//                viewModel.changeView(to: .venues)
//            }
//            .foregroundStyle(.mainPurple)
//            .font(.system(size: 14, weight: .medium))
//            .padding()
            
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
