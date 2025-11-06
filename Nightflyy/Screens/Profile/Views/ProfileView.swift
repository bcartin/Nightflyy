//
//  ProfileView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/8/24.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(Router.self) private var router
    @Environment(ToastsManager.self) private var toastsManager
    @Bindable var viewModel: ProfileViewModel
    var safeArea: EdgeInsets
    var size: CGSize
    
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HeaderImage(size: size, safeArea: safeArea, imageUrl: viewModel.account.profileImageUrl, hideImage: !viewModel.canInteract) {
                    
                    HStack {
                        Text(viewModel.account.username ?? "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                        
                        if viewModel.isPlusProvider {
                            Image("plus_badge")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        else if viewModel.isPlusAccount {
                            Image("plus_badge_user")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 15)
                }
                
                HStack(alignment: .top, spacing: 16) {
                    Text(viewModel.account.name ?? "")
                    
                    Spacer()
                    
                    if viewModel.canInteract {
                        VStack(alignment: .center) {
                            Text("Followers")
                            Text("\(viewModel.account.followers?.count ?? 0)")
                        }
                        .onTapGesture {
                            let viewModel = NetworkViewModel(account: viewModel.account, selectedSegment: 1)
                            router.navigateTo(.Network(viewModel))
                        }
                        
                        VStack(alignment: .center) {
                            Text("Following")
                            Text("\(viewModel.account.following?.count ?? 0)")
                        }
                        .onTapGesture {
                            let viewModel = NetworkViewModel(account: viewModel.account, selectedSegment: 2)
                            router.navigateTo(.Network(viewModel))
                        }
                    }
                }
                .foregroundStyle(.white)
                .font(.system(size: 18))
                .padding(.horizontal, 12)
                
                if viewModel.hasBio {
                    ExpandableText(text: viewModel.account.bio ?? "", isExpanded: false)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                if !viewModel.isSelf {
                    Divider()
                        .background(.white)
                    
                    HStack {
                        
                        IconButton(iconName: viewModel.followButtonProperties.icon, title: viewModel.followButtonProperties.title, color: viewModel.followButtonProperties.color) {
                            viewModel.followButtonAction()
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        IconButton(iconName: "ic_message", title: "Message") {
                            viewModel.messageButtonAction()
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        IconButton(iconName: "ic_invite", title: "Invite", isEnabled: viewModel.canInteract) {
                            let viewModel = InviteToEventViewModel(accountToInvite: viewModel.account)
                            router.navigateTo(.InviteToEvent(viewModel))
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                }
                
                Divider()
                    .background(.white)
                
                if viewModel.isPlusProvider {
                    Button {
                        viewModel.selectPresentView(for: .paywall)
                    } label: {
                        HStack(spacing: 16) {
                            Image("plus_button")
                                .resizable()
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Nightflyy+ Perk")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 11))
                                
                                Text(viewModel.account.perkName ?? "")
                                    .font(.system(size: 14))
                                    .fontWeight(.medium)
                                
                                if let details = viewModel.account.perkDetails {
                                    Text(details)
                                        .font(.system(size: 11))
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    
                    Divider()
                        .background(.white)
                }
                
                if viewModel.canInteract {
                    EventListView(header: "Upcoming Events", viewModels: viewModel.futureHostingEvents)
                    EventListView(header: "Events Attending", viewModels: viewModel.attendingEvents)
                    EventListView(header: "Past Events", viewModels: viewModel.pastHostingEvents)
                }
                else {
                    VStack(alignment: .center, spacing: 8) {
                        Spacer()
                            .frame(height: 120)
                        
                        Image("ic_eye")
                        
                        
                        Text("Account is Private")
                        
                        Spacer()
                    }
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity)
                }
            }
            .overlay(alignment: .top) {
                HeaderView()
            }
        }
        .scrollIndicators(.hidden)
        .coordinateSpace(name: "SCROLL")
        .toolbarVisibility(.hidden, for: .navigationBar)
        .background(.backgroundBlack)
        .task {
            await viewModel.loadAccountEvents()
            viewModel.updateAccount()
        }
        .sheet(isPresented: $viewModel.presentSheetScreen, content: {
            switch viewModel.selectedPresentView {
            case .editScreen:
                EditProfileView(viewModel: EditProfileViewModel())
            case .sendAsMessage:
                SendObjectAsMessageView(viewModel: SendObjectAsMessageViewModel(account: viewModel.account))
            case .report:
                ReportView(viewModel: ReportViewModel(objectId: viewModel.account.uid))
            case .paywall:
                NFPContainerView()
            case .review:
                EmptyView()
            case .none:
                EmptyView()
            }
        })
        .alert(isPresented: $viewModel.presentUnfollowAlert) {
            CustomDialog(title: "Unfollow \(viewModel.account.username ?? "")?",
                         button1: .init(content: "Unfollow", tint: .mainPurple, foreground: .white, action: { folder in
                viewModel.unfollowAccount()
            }),
                         button2: .init(content: "Cancel", tint: .gray, foreground: .white, action: { _ in
                viewModel.presentUnfollowAlert = false
            }))
            .transition(.blurReplace.combined(with: .push(from: .bottom)))
        } background: {
            Rectangle()
                .fill(.primary.opacity(0.35))
        }
        .alert(isPresented: $viewModel.presentBlockAlert) {
            CustomDialog(title: "Block \(viewModel.account.username ?? "")?",
                         button1: .init(content: "Block", tint: .mainPurple, foreground: .white, action: { folder in
                viewModel.handleBlockTapped()
            }),
                         button2: .init(content: "Cancel", tint: .gray, foreground: .white, action: { _ in
                viewModel.presentBlockAlert = false
            }))
            .transition(.blurReplace.combined(with: .push(from: .bottom)))
        } background: {
            Rectangle()
                .fill(.primary.opacity(0.35))
        }
        .buttonDialog(
            isPresented: $viewModel.presentOptionsDialog,
            labelColor: .mainPurple,
            buttonBackground: .backgroundBlackLight
        ) {
            Button("Send Profile as Message") {
                viewModel.selectPresentView(for: .sendAsMessage)
            }
            Button("Report") {
                viewModel.selectPresentView(for: .report)
            }
            Button("Block") {
                viewModel.presentBlockAlert = true
            }
        }
        .interactiveToast($toastsManager.toasts)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProress = minY / height
            
            HStack(spacing: 10) {
                if #available(iOS 26.0, *) { //TODO: Remove when min version is iOS 26
                    Button {
                        router.navigateBack()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                            .labelStyle(.iconOnly)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.white)
                    }
                    .glassEffect()
                } else {
                    Button {
                        router.navigateBack()
                    } label: {
                        HStack {
                            Spacer()
                                .frame(width: 12)
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundStyle(.white)
                            Spacer()
                                .frame(width: 48)
                        }
                    }
                }
                
                Spacer()
                
                if #available(iOS 26.0, *) { //TODO: Remove when min version is iOS 26
                    Button {
                        viewModel.handleOptionsTapped()
                    } label: {
                        Label("Options", image: viewModel.isSelf ? "ic_edit" : "ic_dotmenu")
                            .labelStyle(.iconOnly)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.white)
                    }
                    .glassEffect()
                } else {
                    Button {
                        viewModel.handleOptionsTapped()
                    } label: {
                        Button {
                            viewModel.handleOptionsTapped()
                        } label: {
                            Image(viewModel.isSelf ? "ic_edit" : "ic_dotmenu")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .tint(.white)
                        }
                    }
                }                
                
            }
            .overlay(content: {
                Text(viewModel.account.username ?? "")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .offset(y: -titleProress > 0.75 ? 0 : 45)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25), value: -titleProress > 0.75)
            })
            .padding(.top, safeArea.top + 10)
            .padding([.horizontal, .bottom], 15)
            .background(
                .backgroundBlack
                    .opacity(-progress > 1 ? 1 : 0)
            )
            .offset(y: -minY)
        }
        .frame(height: 35)
    }
    
    
    @ViewBuilder
    func EventListView(header: String, viewModels: [EventListItemViewModel]) -> some View {
        
        VStack(alignment: .leading) {
            Text(header.uppercased())
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .fontWeight(.medium)
            
            if viewModels.isEmpty {
                Text("No Events")
                    .foregroundStyle(.gray)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            else {
                ForEach(viewModels, id: \.self) { viewModel in
                    LazyVStack {
                        EventListItemView(viewModel: viewModel) {
                            viewModel.navigateToEvent()
                        }
                        .task {
                            await viewModel.fetchOwner()
                        }
                        
                    }
                }
            }
            
        }
        .padding(.top, 8)
        .padding(.horizontal, 12)
        
    }
}

//#Preview {
//        ProfileContainer()
//            .preferredColorScheme(.dark)
//}
