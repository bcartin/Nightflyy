//
//  NoCreditsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/12/25.
//

import SwiftUI

struct NoCreditsView: View {
    var body: some View {
        VStack(spacing: 36) {
            Image("plus_button_bw")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("Redeem your next perk in: 00:00:00")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NoCreditsView()
}
