//
//  NFPHelpView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 8/14/25.
//

import SwiftUI

struct NFPHelpView: View {
    @Binding var viewModel: NFPRedeemViewModel
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(spacing: 8) {
            Text("How can we help you?")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 24)
                .multilineTextAlignment(.center)
                .padding(24)
            
            ScrollView(.vertical) {
                ForEach(viewModel.helpOptions, id: \.self) { option in
                    HStack {
                        Text(option.rawValue.capitalized)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .onTapGesture {
                        if let url = URL(string: option.associatedUrl) {
                            openURL(url)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
    }
}

#Preview {
    NFPHelpView(viewModel: .constant(NFPRedeemViewModel()))
}
