//
//  UpdateView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 7/25/25.
//

import SwiftUI

struct UpdateView: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(spacing: 24) {
            Image("slyde_fly")
                .resizable()
                .frame(width: 150, height: 150)
            
            Text("There's a newer version of Nightflyy available.")
            
            Text("Update to the latest version of the app to enjoy all of Nightflyy's latest features.")
                .font(.footnote)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 80)
            
            Button("Update") {
                if let url = URL(string: "itms-apps://apps.apple.com/us/app/nightflyy/id1487722727") {
                    openURL(url)
                }
            }
            .mainButtonStyle()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
    }
}

#Preview {
    UpdateView()
}
