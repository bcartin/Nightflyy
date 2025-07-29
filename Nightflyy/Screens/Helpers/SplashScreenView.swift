//
//  SplashScreenView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/2/25.
//

import SwiftUI
import FirebaseRemoteConfig

struct SplashScreenView: View {
    
    @State var scale: CGSize = CGSize(width: 1.0, height: 1.0)
    
    var body: some View {
        ZStack {
            Image("slyde_fly")
                .resizable()
                .frame(width: 240, height: 240)
                .scaleEffect(scale)
                .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .onAppear{
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                scale = CGSize(width: 1.2, height: 1.2)
            }
        }
        .overlay(alignment: .bottom, content: {
            Text("version \(UIApplication.appVersion)")
                .foregroundStyle(.gray)
                .font(.system(size: 12))
        })
    }
}

#Preview {
    SplashScreenView()
}
