//
//  SideBarMenuView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/9/24.
//

import SwiftUI

struct SideBarMenuView: View {
    
    @Environment(AccountManager.self) private var accountManager
    @Environment(Router.self) private var router
    @Binding var showMenu: Bool
    var safeArea: UIEdgeInsets
    @Binding var viewModel: SideBarMenuViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                
                UserImageRound(imageUrl: accountManager.account?.profileImageUrl, size: 72)
                    .padding(.leading)
                
                VStack(alignment: .center) {
                    Text(accountManager.account?.username ?? "")
                        .font(.system(size: 24))
                    
                    Button {
                        showMenu = false
                        viewModel.navigateToProfile()
                    } label: {
                        Text("View User Profile")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 24)
                
            }
            
            Button {
                
            } label: {
                HStack {
                    Text("Upgrade to Nightflyy+")
                        .foregroundStyle(.white)
                        .font(.custom("NeuropolXRg-Regular", size: 17))
                        .padding()
                    
                    Spacer()
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [.backgroundBlack, .backgroundBlack, .mainPurple]), startPoint: .leading, endPoint: .trailing)
                )
            }

            
            SideBarHeader(title: "ACCOUNT")
                
            SideBarButton(.accountInfo) {
                viewModel.selectMenuItem(.accountInfo)
                showMenu = false
            }
            
            SideBarButton(.eventPreferences){
                viewModel.selectMenuItem(.eventPreferences)
                showMenu = false
            }
            
            SideBarHeader(title: "SETTINGS")
            
            SideBarButton(.privacy)
            SideBarButton(.pushNotifications)
            
            SideBarHeader(title: "ABOUT")
            
            SideBarButton(.termsOfService)
            SideBarButton(.privacyPolicy)
            SideBarButton(.helpUs)
            SideBarButton(.rateUs)
            SideBarButton(.shareApp)
            
            SideBarButton(.logout) {
                try? AuthenticationManager.shared.logOut()
            }
        }
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .environment(\.colorScheme, .dark)
        .background(.backgroundBlack)
    }
    
    @ViewBuilder
    func SideBarHeader(title: String) -> some View {
        Text(title)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .foregroundStyle(.white)
            .font(.system(size: 18))
            .fontWeight(.medium)
            .background(.black)
    }
    
    @ViewBuilder
    func SideBarButton(_ tab: MenuItem, onTap: @escaping () -> () = {}) -> some View {
        Button(action:
                onTap,
               label: {
            HStack(spacing: 12) {
                if let imageName = tab.image {
                    Image(systemName: imageName)
                }
                Text(tab.title)
                    .font(.system(size: 17))
                    
                Spacer(minLength: 0)
            }
            .foregroundStyle(.white)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .contentShape(.rect)
            .foregroundStyle(.primary)
        })
    }
}

#Preview {
    SideBarMenuView(showMenu: .constant(false), safeArea: UIEdgeInsets(), viewModel: .constant(.init()))
}
