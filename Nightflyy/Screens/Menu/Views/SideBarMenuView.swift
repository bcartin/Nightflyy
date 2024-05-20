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
                        router.navigateTo(.Profile)
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
                
            SideBarButton(.accountInfo)
            SideBarButton(.eventPreferences)
            
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
        Button(action: onTap, label: {
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
    
    //Sample tabs
    enum MenuItem: String, CaseIterable {
        case accountInfo = "1"
        case eventPreferences = "2"
        case privacy = "3"
        case pushNotifications = "4"
        case termsOfService = "5"
        case privacyPolicy = "6"
        case helpUs = "7"
        case rateUs = "8"
        case shareApp = "9"
        case logout = "0"
        
        var title: String {
            switch self {
            case .accountInfo:
                return "Edit Account Info"
            case .eventPreferences:
                return "Edit Event Preferences"
            case .privacy:
                return "Privacy Settings"
            case .pushNotifications:
                return "Push Notifications"
            case .termsOfService:
                return "Terms of Service"
            case .privacyPolicy:
                return "Privacy Policy"
            case .helpUs:
                return "Help Us Improve"
            case .rateUs:
                return "Rate Us"
            case .shareApp:
                return "Share App"
            case .logout:
                return "Logout"
            }
        }
        
        var image: String? {
            switch self {
            case .logout:
                return "rectangle.portrait.and.arrow.forward.fill"
            default:
                return nil
            }
        }
    }
}

#Preview {
    SideBarMenuView(showMenu: .constant(false), safeArea: UIEdgeInsets())
}
