//
//  OverlayView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/24/24.
//

import SwiftUI

struct OverlayView: View {
    
    @State var scale: CGSize = CGSize(width: 1.0, height: 1.0)
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Image("slyde_background")
                .resizable()
            
            Image("slyde_fly")
                .resizable()
                .frame(width: 240, height: 240, alignment: .center)
                .scaleEffect(scale)
            
            VStack {
                Spacer()
                
                Text("Version \(AppVersionProvider.appVersion())")
                    .foregroundStyle(Color.white)
                    .font(.footnote)
                    .padding()
            }
        }
        .ignoresSafeArea()
        .background(
            Color.backgroundBlack
        )
        .onAppear{
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                scale = CGSize(width: 1.2, height: 1.2)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                
                withAnimation(.easeIn(duration: 0.2)) {
                    isPresented.toggle()
                }
            })
        }
    }
}

#Preview {
    OverlayView(isPresented: .constant(true))
}

