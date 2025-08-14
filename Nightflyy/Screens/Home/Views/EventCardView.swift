//
//  EventCardView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 10/10/24.
//

import SwiftUI

struct EventCardView: View {
    
    @Bindable var viewModel: EventCardViewModel
    var size: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                UserImageRound(imageUrl: viewModel.eventOwner?.profileImageUrl, size: 24)
                
                Text(viewModel.ownerName)
                    .foregroundStyle(.white)
                    .font(.system(size: 16))
                
                Spacer()
            }
            .padding(.bottom, 8)
            .highPriorityGesture(
                TapGesture()
                    .onEnded {
                        viewModel.navigateToProfile()
                    }
            )
            
            ZStack(alignment: .top) {
                EventImage(imageUrl: viewModel.event.eventFlyerUrl, size: CGSize(width: size.width - 110, height: (size.width - 110) * 1.375))
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.bottom)
                    .onTapGesture {
                        viewModel.navigateToEventDetails()
                    }
                
                HStack() {
                    Spacer()
                    
                    VStack(alignment: .trailing ,spacing: 12) {
                        
                        Text(viewModel.eventDateString)
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(.mainPurple)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.trailing, 18)
                            .padding(.top, 4)
                        
                        Spacer()
                            .frame(height: (size.width - 255) * 1.375)
                        
                        Menu {
                            Button("Interested") {
                                viewModel.markAsInterested()
                            }
                            Button("Going") {
                                viewModel.markAsAttenging()
                            }
                            Button("Not Going") {
                                viewModel.markAsNotAttending()
                            }
                        } label: {
                            Image(viewModel.attendingButtonProperties.icon)
                                .resizable()
                                .padding(8)
                                .frame(width: 42, height: 42)
                                .foregroundStyle(viewModel.attendingButtonProperties.color)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.2))
                                        .shadow(color: .white, radius: 10)
                                )
                                .overlay {
                                    Circle()
                                        .stroke(viewModel.attendingButtonProperties.color, lineWidth: 1)
                                }
                        }
                        
                        Menu {
                            ShareLink(item: viewModel.shareLink, message: Text("Check out this event on Nightflyy!")) {
                                Label("Share Event", systemImage: "")
                            }
                            Button("Invite Friends") {
                                viewModel.handleSendAsMessageTapped()
                            }
                        } label: {
                            Image("ic_share")
                                .resizable()
                                .padding(8)
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.white)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.2))
                                        .shadow(color: .white, radius: 10)
                                )
                                .overlay {
                                    Circle()
                                        .stroke(.white, lineWidth: 1)
                                }
                        }
                        
                        Button {
                            viewModel.navigateToGuestList()
                        } label: {
                            Image("ic_crowd")
                                .resizable()
                                .padding(8)
                                .frame(width: 42, height: 42)
                                .foregroundStyle(.white)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.2))
                                        .shadow(color: .white, radius: 10)
                                )
                                .overlay {
                                    Circle()
                                        .stroke(.white, lineWidth: 1)
                                }
                        }
                        
                    }
                    .frame(minHeight: .zero)
                }
            }
            
            Text(viewModel.event.eventName ?? "")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 4)
            
            HStack {
                Image("ic_pin")
                    .resizable()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(.mainPurple)
                
                Text(viewModel.eventLocation)
                    .font(.system(size: 17))
                    .foregroundStyle(.white)
                    .padding(.trailing, 14)
            }
            .frame(maxWidth: .infinity)
            
            
        }
        .frame(width: size.width - 86)
        .background(.clear)
        .sheet(isPresented: $viewModel.presentInviteScreen, onDismiss: nil) {
            InviteFromEventView(viewModel: InviteFromEventViewModel(event: viewModel.event))
        }
        .sheet(isPresented: $viewModel.presentSendAsMessageScreen, onDismiss: nil) {
            SendObjectAsMessageView(viewModel: SendObjectAsMessageViewModel(event: viewModel.event))
        }
        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
    }
}

#Preview {
    EventCardView(viewModel: EventCardViewModel(event: TestData.events.first!),
                  size: CGSize(width: UIScreen.main.bounds.size.width, height: 392))
}

