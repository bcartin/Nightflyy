//
//  LoadingView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/24/24.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var degree:Int = 270
    @State private var spinnerLength = 0.6
    
    var body: some View {
        ZStack {
            VStack {
                Circle()
                    .trim(from: 0.0,to: spinnerLength)
                    .stroke(LinearGradient(colors: [.mainPurple,.onlineBlue], startPoint: .topLeading, endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 4.0,lineCap: .round,lineJoin:.round))
                    .animation(.easeIn(duration: 1.2).repeatForever(autoreverses: true), value: spinnerLength)
                    .frame(width: 60,height: 60)
                    .rotationEffect(Angle(degrees: Double(degree)))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: degree)
                    .onAppear{
                        degree = 270 + 360
                        spinnerLength = 0
                    }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.5))
    }
}

#Preview {
    LoadingView()
}
