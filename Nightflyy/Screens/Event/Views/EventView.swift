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
                                ClaimView()
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
                        
                        IconButton(iconName: viewModel.attendingButtonProperties.icon, title: viewModel.attendingButtonProperties.title, color: viewModel.attendingButtonProperties.color) {
                            viewModel.presentInterestedDialog = true
                        }
                        .frame(maxWidth: .infinity)
                        
                        IconButton(iconName: "ic_share", title: "Share") {
                            viewModel.presentShareDialog.toggle()
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        IconButton(iconName: "ic_crowd", title: "Guest List") {
                            let viewModel = EventGuestListViewModel(event: viewModel.event, selectedSegment: 1)
                            router.navigateTo(.EventGuestList(viewModel))
                        }
                        .frame(maxWidth: .infinity)
                        
                        IconButton(iconName: "ic_chat", title: "Comments", isEnabled: true) {
                            Task {
                                await viewModel.fetchEventComments()
                                viewModel.preseentCommentsScreen = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                    
                    Divider()
                        .background(.white)
                    
                    HStack {
                        EventItemView(header: "Event Type", value: viewModel.event.eventIsPrivate ?? false ? "Private" : "Public")
                        
                        EventItemView(header: "Time", value: viewModel.startTimeString + " - " + viewModel.endTimeString)
                    }
                    
                    HStack {
                        EventItemView(header: "Cover Charge", value: viewModel.eventPrice)
                        
                        EventItemView(header: "Going", value: viewModel.numberOfAttendees)
                    }
                    
                    EventItemView(header: "Venue", value: viewModel.event.eventVenue ?? "", itemColor: viewModel.venueHasProfile ? .mainPurple : .white) {
                        viewModel.navigateToVenue()
                    }
                    
                    EventItemView(header: "Address", value: viewModel.event.eventAddress ?? "", underline: true, action: {
                        viewModel.openMapsWithAddress()
                    })
                    
                    ExpandableText(label: "Details", text: viewModel.event.eventDetails ?? "", isExpanded: false)
                    
                    PillListView(header: "Music", items: viewModel.event.eventMusic ?? [])
                    
                    PillListView(header: "Crowd", items: viewModel.event.eventCrowds ?? [])
                        .padding(.bottom, 24)
                }
                .overlay(alignment: .top) {
                    HeaderView()
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
                        .background{
                            Capsule()
                                .fill(.mainPurple.gradient)
                        }
                        .padding(.horizontal, 32)
                }
                
            }
            
            if showBanner {
                VStack {
                    Spacer()
                    
                    BasicCachedAsyncImage(url: URL(string: viewModel.event.eventFlyerUrl ?? ""))
                    .aspectRatio(contentMode: .fit)
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
//            Button("Invite Friends") {
//                viewModel.handleInviteFriendsTapped()
//            }
            
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
        .sheet(isPresented: $viewModel.presentSendAsMessageScreen, onDismiss: nil) {
            SendObjectAsMessageView(viewModel: SendObjectAsMessageViewModel(event: viewModel.event))
        }
        .sheet(isPresented: $viewModel.preseentCommentsScreen) {
            EventCommentsListView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
        }
        
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let height = size.height * 0.45
            let progress = minY / (height * (minY > 0 ? 0.5 : 0.8))
            let titleProress = minY / height
            
            HStack(spacing: 10) {
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
                
                Spacer()
                
                if viewModel.shouldShowOptionsButton {
                    Button {
                        viewModel.presentOptionsDialog.toggle()
                    } label: {
                        Image("ic_dotmenu")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .tint(.white)
                    }
                }


            }
            .overlay(content: {
                Text(viewModel.event.eventName ?? "")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .offset(y: -titleProress > 0.75 ? 0 : 45)
                    .clipped()
                    .padding(.horizontal, 36)
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
    func EventItemView(header: String, value: String, itemColor: Color = .white, underline: Bool = false, action: ButtonAction? = nil) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(header.uppercased())
                .foregroundStyle(.gray)
                .font(.system(size: 13))
            Text(value)
                .foregroundStyle(itemColor)
                .underline(underline)
                .onTapGesture {
                    guard let action = action else { return }
                    action()
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    func ClaimView() -> some View {
        ZStack {
            Rectangle()
                .fill(.mainPurple)
                .frame(height: 100)
            
            VStack {
                Text("You have been invited to claim this event")
                    .foregroundStyle(.white)
                
                HStack(spacing: 12) {
                    Button("Accept") {
                        viewModel.claimEvent()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .foregroundStyle(.mainPurple)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button("Decline") {
                        viewModel.declineEvent()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .foregroundStyle(.mainPurple)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

//#Preview {
//    GeometryReader {
//        let safeArea = $0.safeAreaInsets
//        let size = $0.size
//        
//        EventView(viewModel: EventViewModel(event: TestData.events.first!), safeArea: safeArea, size: size)
//            .ignoresSafeArea(.container, edges: .top)
//    }
//}
