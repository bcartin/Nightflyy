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
    @State private var hasLoadedInitialData = false
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
                        } else if viewModel.isPlusAccount {
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
                            Text("\(viewModel.account.followerCount)")
                        }
                        .font(.system(size: 14))
                        .onTapGesture {
                            let viewModel = NetworkViewModel(account: viewModel.account, selectedSegment: 1)
                            router.navigateTo(.network(viewModel))
                        }

                        VStack(alignment: .center) {
                            Text("Following")
                            Text("\(viewModel.account.followingCount)")
                        }
                        .font(.system(size: 14))
                        .onTapGesture {
                            let viewModel = NetworkViewModel(account: viewModel.account, selectedSegment: 2)
                            router.navigateTo(.network(viewModel))
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

                        IconButton(iconName: viewModel.followButtonProperties.icon,
                                   title: viewModel.followButtonProperties.title,
                                   color: viewModel.followButtonProperties.color) {
                            viewModel.followButtonAction()
                        }
                        .frame(maxWidth: .infinity)

                        IconButton(iconName: "ic_message", title: "Message") {
                            viewModel.messageButtonAction()
                        }
                        .frame(maxWidth: .infinity)

                        IconButton(iconName: "ic_invite", title: "Invite", isEnabled: viewModel.canInteract) {
                            let viewModel = InviteToEventViewModel(accountToInvite: viewModel.account)
                            router.navigateTo(.inviteToEvent(viewModel))
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
                        HStack {
                            Image("plus_badge")
                                .resizable()
                                .frame(width: 30, height: 30)

                            VStack(alignment: .leading) {
                                Text("Nightflyy+ Perk")
                                    .font(.system(size: 12))
                                    .foregroundColor(.onlineBlue)

                                Text(viewModel.account.perkName ?? "")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.white)

                                Text(viewModel.account.perkDetails ?? "")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.onlineBlue)
                        }
                        .padding(8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.onlineBlue, lineWidth: 1)
                        }
                        .padding(12)
                    }

                }

                if viewModel.canInteract {
                    EventListSection(header: "Upcoming Events", viewModels: viewModel.futureHostingEvents, headerFont: .system(size: 14))
                    EventListSection(header: "Events Attending", viewModels: viewModel.attendingEvents, headerFont: .system(size: 14))
                    EventListSection(header: "Past Events", viewModels: viewModel.pastHostingEvents, headerFont: .system(size: 14))
                } else {
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
                CollapsingHeaderBar(title: viewModel.account.username ?? "",
                                    size: size,
                                    safeArea: safeArea,
                                    optionsImage: viewModel.isSelf ? "ic_edit" : "ic_dotmenu",
                                    onOptions: { viewModel.handleOptionsTapped() })
            }
        }
        .scrollIndicators(.hidden)
        .coordinateSpace(name: "SCROLL")
        .toolbarVisibility(.hidden, for: .navigationBar)
        .background(.backgroundBlack)
        .task {
            viewModel.updateAccount()

            guard !hasLoadedInitialData else { return }
            hasLoadedInitialData = true
            await viewModel.loadAccountEvents()

        }
        .sheet(item: $viewModel.selectedPresentView) { screen in
            switch screen {
            case .editScreen:
                if let editVM = viewModel.editProfileViewModel {
                    EditProfileView(viewModel: editVM)
                }
            case .report:
                ReportView(viewModel: ReportViewModel(objectId: viewModel.account.uid))
            case .paywall:
                NFPContainerView()
            case .review:
                EmptyView()
            }
        }
        .alert(isPresented: $viewModel.presentUnfollowAlert) {
            CustomDialog(title: "Unfollow \(viewModel.account.username ?? "")?",
                         button1: .init(content: "Unfollow", tint: .mainPurple, foreground: .white, action: { _ in
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
                         button1: .init(content: "Block", tint: .mainPurple, foreground: .white, action: { _ in
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
                viewModel.navigateToSendAsMessage()
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
}

// #Preview {
//        ProfileContainer()
//            .preferredColorScheme(.dark)
// }
