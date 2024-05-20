//
//  BottomSheetView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/15/24.
//

import SwiftUI

struct BottomSheetView: View {
    
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            }
            else {
                Rectangle()
                    .fill(.backgroundBlack)
                    .shadow(color: .onlineBlue.opacity(0.5), radius: 5, y: -10)
                    .overlay {
                        UseYourPerk(expandSheet: $expandSheet, animation: animation) 
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
            }
            
        }
        .frame(height: 70)
        .overlay(alignment: .bottom, content: {
            Rectangle()
                .fill(.gray.opacity(0.4))
                .frame(height: 1)
                .offset(y: -5)
        })
        .offset(y: -83)
    }
}

struct UseYourPerk: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    var body: some View {
        HStack {
            if !expandSheet {
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
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}

  

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


