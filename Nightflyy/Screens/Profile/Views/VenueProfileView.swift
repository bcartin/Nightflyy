//
//  VenueProfileView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/22/25.
//

import SwiftUI

struct VenueProfileView: View {

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

                        Spacer()
                    }
                    .padding(.bottom, 15)
                }

                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(viewModel.account.name ?? "")
                        Text(viewModel.account.venueType?.capitalized ?? "")
                            .foregroundStyle(.mainPurple)

                    }

                    Spacer()

                    VStack(alignment: .center) {
                        Text("Followers")
                        Text("\(viewModel.account.followerCount)")
                    }
                    .onTapGesture {
                        let viewModel = NetworkViewModel(account: viewModel.account, selectedSegment: 1)
                        router.navigateTo(.network(viewModel))
                    }

                    VStack(alignment: .center) {
                        Text("Following")
                        Text("\(viewModel.account.followingCount)")
                    }
                    .onTapGesture {
                        let viewModel = NetworkViewModel(account: viewModel.account, selectedSegment: 2)
                        router.navigateTo(.network(viewModel))
                    }
                }
                .foregroundStyle(.white)
                .font(.system(size: 18))
                .padding(.horizontal, 12)

                if viewModel.hasBio {
                    if viewModel.hasBio {
                        ExpandableText(text: viewModel.account.bio ?? "", isExpanded: false)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }

                HStack {
                    Group {
                        Text(viewModel.formatedRating)

                        RatingStarsView(rating: viewModel.account.rating ?? 0)

                        Text("(\(viewModel.numberOfReviews))")
                    }
                    .onTapGesture {
                        viewModel.selectPresentView(for: .review)
                    }

                    Spacer()

                    Button {
                        viewModel.goToReviewScreen()
                    } label: {
                        Text("+ Review")
                    }

                }
                .padding(.horizontal, 12)

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

                        IconButton(iconName: "ic_contact", title: "Contact", isEnabled: viewModel.canContact) {
                            viewModel.presentContactDialog = true
                        }
                        .frame(maxWidth: .infinity)

                        IconButton(iconName: "ic_message", title: "Message") {
                            viewModel.messageButtonAction()
                        }
                        .frame(maxWidth: .infinity)

                        IconButton(iconName: "ic_website", title: "Website", isEnabled: viewModel.hasWebsite) {
                            viewModel.openWebsite()
                        }
                        .frame(maxWidth: .infinity)

                    }
                }

                Divider()
                    .background(.white)

                VStack(alignment: .leading, spacing: 2) {
                    Text("ADDRESS")
                        .foregroundStyle(.gray)
                        .font(.system(size: 13))

                    Text(viewModel.account.address ?? "")
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .onTapGesture {
                    viewModel.openMapsWithAddress()
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

                PillListView(header: "MUSIC", items: viewModel.account.music ?? [])

                PillListView(header: "CROWD", items: viewModel.account.clientele ?? [])

                EventListSection(header: "Upcoming Events", viewModels: viewModel.futureHostingEvents)
                if viewModel.isPersonalAccount {
                    EventListSection(header: "Events Attending", viewModels: viewModel.attendingEvents)
                }
                EventListSection(header: "Past Events", viewModels: viewModel.pastHostingEvents)
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
            await viewModel.loadAccountEvents()
            await viewModel.getNumberOfReviews()
            viewModel.updateAccount()
        }
        .sheet(item: $viewModel.selectedPresentView) { screen in
            switch screen {
            case .editScreen:
                EditVenueProfileView(viewModel: EditVenueProfileViewModel())
            case .report:
                ReportView(viewModel: ReportViewModel(objectId: viewModel.account.uid))
            case .paywall:
                NFPContainerView()
            case .review:
                ReviewsDetailView(viewModel: ReviewsDetailViewModel(account: viewModel.account))
            }
        }
        .alert(isPresented: $viewModel.presentUnfollowAlert) {
            CustomDialog(title: "Unfollow \(viewModel.account.username ?? "")",
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
        .buttonDialog(
            isPresented: $viewModel.presentContactDialog,
            labelColor: .mainPurple,
            buttonBackground: .backgroundBlackLight
        ) {
            if viewModel.hasPhoneNumber {
                Link("Call \(viewModel.prettyPhoneNumber)", destination: viewModel.callUrl!)
            }
            if viewModel.hasBusinessEmail {
                Link("Email", destination: URL(string: "mailto://\(viewModel.businessEmail ?? "")")!)
            }
        }
        .interactiveToast($toastsManager.toasts)
    }
}
