//
//  NetworkUserView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/15/24.
//

import SwiftUI

struct NetworkUserView: View {
    
    @Environment(Router.self) private var router
    var viewModel: NetworkUserViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            UserImageRound(imageUrl: viewModel.account?.profileImageUrl, size: 48)
            Text(viewModel.account?.username ?? "")
            
            if viewModel.account?.plusProvider ?? false {
                Image("plus_badge")
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            else if viewModel.account?.plusMember ?? false {
                Image("plus_badge_user")
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            
            Spacer()
            
            //TODO: Add Button functionality
            
//            Button {
//                
//            } label: {
//                Text(viewModel.buttonLabel)
//                    .font(.system(size: 13))
//                    .foregroundStyle(.white)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(viewModel.buttonBackgroundColor.gradient)
//                            .stroke(viewModel.buttonBorderColor, lineWidth: 1)
//                            
//                    )
//            }

        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
}

#Preview {
    NetworkUserView(viewModel: NetworkUserViewModel(selectedSegment: 1))
        .preferredColorScheme(.dark)
}
