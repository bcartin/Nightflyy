//
//  SideBarMenuView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/9/24.
//

import SwiftUI
import StoreKit

struct SideBarMenuView: View {
    
    @Environment(\.requestReview) var requestReview
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
                NFPManager.shared.showNFPView = true
                showMenu = false
            } label: {
                HStack {
                    Text(viewModel.bannerText)
                        .foregroundStyle(.white)
                        .font(.custom("NeuropolXRg-Regular", size: 17))
                        .padding()
                    
                    Spacer()
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [.backgroundBlack, .backgroundBlack, viewModel.isPlusMember ? .onlineBlue : .mainPurple]), startPoint: .leading, endPoint: .trailing)
                )
            }

            
            SideBarHeader(title: "ACCOUNT")
                
            SideBarButton(.accountInfo(type: AccountManager.shared.account?.accountType ?? .personal)) {
                viewModel.selectMenuItem(.accountInfo(type: AccountManager.shared.account?.accountType ?? .personal))
                showMenu = false
            }
            
            SideBarButton(.eventPreferences) {
                viewModel.selectMenuItem(.eventPreferences)
                showMenu = false
            }
            
            SideBarHeader(title: "SETTINGS")
            
            SideBarButton(.privacy){
                viewModel.selectMenuItem(.privacy)
                showMenu = false
            }
            
            SideBarButton(.pushNotifications) {
                viewModel.selectMenuItem(.pushNotifications)
                showMenu = false
            }
            
            SideBarHeader(title: "ABOUT")
            
            SideBarButton(.termsOfService){
                viewModel.selectMenuItem(.termsOfService)
                showMenu = false
            }
            
            SideBarButton(.privacyPolicy){
                viewModel.selectMenuItem(.privacyPolicy)
                showMenu = false
            }
            
            SideBarButton(.helpUs){
                viewModel.selectMenuItem(.helpUs)
                showMenu = false
            }
            
            SideBarButton(.rateUs) {
                requestReview()
            }
            
            ShareLink(item: URL(string: "https://apps.apple.com/us/app/id1487722727")!, message: Text("You have been invited to join the exclusive nightlife community! Download Nightflyy now.")) {
                HStack(spacing: 12) {
                    Text("Share")
                        .font(.system(size: 17))
                        
                    Spacer(minLength: 0)
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .contentShape(.rect)
                .foregroundStyle(.primary)
            }
            
            HStack {
                SideBarButton(.logout) {
                    showMenu = false
                    try? AuthenticationManager.shared.logOut()
                }
                
                Spacer()
                
                Text("version \(UIApplication.appVersion)")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
                    .padding(.horizontal)
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
