//
//  MemberView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct MemberView: View {
    
    @State private var glow = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 24))
                        .padding()
                }
            }
            
            Spacer()
            
//            RedeemButtonView()
//            NoCreditsView()
//            RedeemCodeView()
            CreditRedeemedView()
            
            Spacer()
            
            Button("See All Nightflyy+ Venues") {
                
            }
            .foregroundStyle(.mainPurple)
            .font(.system(size: 14, weight: .medium))
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .gesture(
            DragGesture()
                .onChanged({ value in
                }).onEnded({ value in
                    if value.location.y - value.startLocation.y > 150 {
                        dismiss()
                    }
                })
        )
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 3)
                .fill(.gray.opacity(0.9))
                .frame(width: 86, height: 6)
        }
    }
}

#Preview {
    MemberView()
}
