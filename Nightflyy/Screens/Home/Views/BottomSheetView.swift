//
//  BottomSheetView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/15/24.
//

import SwiftUI

struct BottomSheetView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.backgroundBlack)
                .shadow(color: .onlineBlue.opacity(0.5), radius: 5, y: -10)
                .overlay {
                    UseYourPerk()
                }
            
        }
        .frame(height: 70)
    }
}

struct UseYourPerk: View {
    
    var body: some View {
        HStack {
                Image(systemName: "chevron.up")
                    .foregroundStyle(.onlineBlue)
                
                Spacer()
                
                Text("Use your perk")
                    .foregroundStyle(.onlineBlue)
                    .font(.custom("NeuropolXRg-Regular", size: 17))
                    .padding(.vertical, 12)
                    .padding(.trailing, 24)
                
                Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
    }
}

  

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


