//
//  EventView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/14/24.
//

import SwiftUI

struct EventView: View {

    @Environment(Router.self) private var router
    @Environment(\.openURL) var openURL
    @Environment(ToastsManager.self) private var toastsManager
    @Bindable var viewModel: EventViewModel
    var safeArea: EdgeInsets
    var size: CGSize
    @State var showBanner: Bool = false

    var body: some View {
        @Bindable var toastsManager = toastsManager

        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    HeaderImage(size: size, safeArea: safeArea, imageUrl: viewModel.event.eventFlyerUrl) {
                        VStack {
                            if viewModel.showClaimView {
                                ClaimEventBanner(onAccept: { viewModel.claimEvent() }, onDecline: { viewModel.declineEvent() })
                            }

                            HStack {
                                Text(viewModel.event.eventName ?? "")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                    .lineLimit(1)

                                Spacer()

                                Text(viewModel.weekday)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.leading, 12)
                            }
                        }
                    }
                    .onLongPressGesture {
                        withAnimation {
                            showBanner = true
                        }
                    } onPressingChanged: { isPressing in
                        if !isPressing {
                            showBanner = false
                        }
                    }

                    HStack(alignment: .top, spacing: 0) {
                        Text("Hosted by ")
                        Button {
                            viewModel.navigateToOwnerProfile()
                        } label: {
                            Text(viewModel.eventOwnerName)
                                .foregroundStyle(.mainPurple)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        Text(viewModel.month + " " + viewModel.day)
                    }
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .padding(.horizontal, 12)

                    Divider()
                        .background(.white)

                    HStack {

                        IconButton(iconName: viewModel.attendingButtonProperties.icon,
                                   title: viewModel.attendingButtonProperties.title,
                                   color: viewModel.attendingButtonProperties.color) {
                            viewModel.presentInterestedDialog = true
                        }
                        .frame(maxWidth: .infinity)

                        IconButton(iconName: "ic_share", title: "Share") {
                            viewModel.presentShareDialog.toggle()
                        }
                        .frame(maxWidth: .infinity)

                        IconButton(iconName: "ic_crowd", title: "Guest List") {
                            let viewModel = EventGuestListViewModel(event: viewModel.event, selectedSegment: 1)
                            router.navigateTo(.eventGuestList(viewModel))
                        }
                        .frame(maxWidth: .infinity)

                        IconButton(iconName: "ic_chat", title: "Comments", isEnabled: true) {
                            Task {
                                await viewModel.fetchEventComments()
                                viewModel.preseentCommentsScreen = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .topLeading) {
                            if viewModel.hasNewComments && viewModel.isOwner {
                                Text(viewModel.newComments)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white)
                                    .padding(6)
                                    .background {
                                        Circle()
                                            .fill(.red)
                                    }
                            }

                        }

                    }

                    Divider()
                        .background(.white)

                    if viewModel.event.hasPerk ?? false {
                        EventPerkCard(name: viewModel.event.perkName ?? "", details: viewModel.event.perkDetails ?? "") {
                            viewModel.presentPaywall.toggle()
                        }
                    }

                    HStack {
                        EventDetailItem(header: "Event Type", value: viewModel.event.eventIsPrivate ?? false ? "Private" : "Public")

                        EventDetailItem(header: "Time", value: viewModel.startTimeString + " - " + viewModel.endTimeString)
                    }

                    HStack {
                        EventDetailItem(header: "Cover Charge", value: viewModel.eventPrice)

                        EventDetailItem(header: "Going", value: viewModel.numberOfAttendees)
                    }

                    EventDetailItem(header: "Venue",
                                    value: viewModel.event.eventVenue ?? "",
                                    itemColor: viewModel.venueHasProfile ? .mainPurple : .white) {
                        viewModel.navigateToVenue()
                    }

                    EventDetailItem(header: "Address", value: viewModel.event.eventAddress ?? "", underline: true, action: {
                        viewModel.openMapsWithAddress()
                    })

                    ExpandableText(label: "Details", text: viewModel.event.eventDetails ?? "", isExpanded: false)

                    PillListView(header: "Music", items: viewModel.event.eventMusic ?? [])

                    PillListView(header: "Crowd", items: viewModel.event.eventCrowds ?? [])
                        .padding(.bottom, 24)
                }
                .overlay(alignment: .top) {
                    CollapsingHeaderBar(title: viewModel.event.eventName ?? "",
                                        size: size,
                                        safeArea: safeArea,
                                        titleHorizontalPadding: 36,
                                        optionsLabel: "Menu",
                                        onOptions: viewModel.shouldShowOptionsButton ? { viewModel.presentOptionsDialog.toggle() } : nil)
                }

            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "SCROLL")
            .toolbar(.hidden, for: .navigationBar)

            if viewModel.hasLink {

                Button {
                    if let url = URL(string: viewModel.event.ticketingUrl ?? "") {
                        openURL(url)
                    }
                } label: {
                    Text("RSVP")
                        .foregroundStyle(.white)
                        .font(.system(size: 13, weight: .medium))
                        .frame(width: 120, height: 40)
                        .background {
                            Capsule()
                                .fill(.mainPurple.gradient)
                        }
                        .padding(.horizontal, 32)
                }

            }

            if showBanner {
                VStack {
                    Spacer()

                    BasicCachedAsyncImage(url: URL(string: viewModel.event.eventFlyerUrl ?? "")).scaledToFit()
                    .frame(width: size.width)
                    .background(.clear)

                    Spacer()
                }
                .frame(height: size.height)
                .background(.ultraThinMaterial)
            }

        }
        .toolbar(.hidden, for: .navigationBar)
        .background(.backgroundBlack)
        .buttonDialog(
            isPresented: $viewModel.presentInterestedDialog,
            labelColor: .mainPurple,
            buttonBackground: .backgroundBlackLight
        ) {
            Button("Interested") {
                viewModel.markAsInterested()
                viewModel.presentInterestedDialog = false
            }
            Button("Going") {
                viewModel.markAsAttenging()
                viewModel.presentInterestedDialog = false
            }
            Button("Not Going") {
                viewModel.markAsNotAttending()
                viewModel.presentInterestedDialog = false
            }
        }
        .buttonDialog(isPresented: $viewModel.presentOptionsDialog, buttons: {
            Button("Edit Event") {
                viewModel.goToEditEvent()
            }
            Button("Cancel Event") {
                viewModel.presentCancelAlert = true
                viewModel.presentOptionsDialog = false
            }
        })
        .buttonDialog(isPresented: $viewModel.presentShareDialog, buttons: {

            ShareLink(item: viewModel.shareLink, message: Text("Check out this event on Nightflyy!")) {
                Label("Share Event", systemImage: "")
            }

            Button("Invite Friends") {
                viewModel.handleSendAsMessageTapped()
            }
        })
        .interactiveToast($toastsManager.toasts)
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        .alert(isPresented: $viewModel.presentCancelAlert) {
            CustomDialog(title: "Delete Event?",
                         content: "This cannot be undone.",
                         button1: .init(content: "Delete", tint: .red, foreground: .white, action: { _ in
                viewModel.deleteEvent()
            }),
                         button2: .init(content: "Cancel", tint: .gray, foreground: .white, action: { _ in
                viewModel.presentCancelAlert = false
            }))
            .transition(.blurReplace.combined(with: .push(from: .bottom)))
        } background: {
            Rectangle()
                .fill(.primary.opacity(0.35))
        }
        .sheet(isPresented: $viewModel.presentInviteScreen, onDismiss: nil) {
            InviteFromEventView(viewModel: InviteFromEventViewModel(event: viewModel.event))
        }
        .sheet(isPresented: $viewModel.preseentCommentsScreen, onDismiss: {
            viewModel.updateCommentsCounter()
        }, content: {
            EventCommentsListView(viewModel: viewModel)
                .presentationDetents([.large])
        })
        .sheet(isPresented: $viewModel.presentPaywall) {
            NFPContainerView()
        }

    }
}

// #Preview {
//    GeometryReader {
//        let safeArea = $0.safeAreaInsets
//        let size = $0.size
//        
//        EventView(viewModel: EventViewModel(event: TestData.events.first!), safeArea: safeArea, size: size)
//            .ignoresSafeArea(.container, edges: .top)
//    }
// }
