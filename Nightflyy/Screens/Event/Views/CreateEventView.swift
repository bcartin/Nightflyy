//
//  CreateEventView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/24/25.
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
    
    @Bindable var viewModel: CreateEventViewModel
    @State var imageItem: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack() {
                    let width = UIScreen.main.bounds.size.width - 48
                    PhotosPicker(selection: $imageItem, matching: .images) {
                        if let image = viewModel.flyerImage {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: width * 1.375)
                                .cornerRadius(5, corners: .allCorners)
                                .padding(.vertical, 20)
                        }
                        else if let flyerUrl = viewModel.event.eventFlyerUrl {
                            CachedAsyncImage(url: URL(string: flyerUrl), size: .init(width: width, height: width * 1.375), shape: .rect(cornerRadius: 5), contentMode: .fit)
                            .padding(.vertical, 20)
                        }
                        else {
                            (Text(Image(systemName: "plus.rectangle.portrait")) + Text(" Add Flyer"))
                                .mainButtonStyle()
                                .padding(.vertical, 20)
                        }
                    }
                    
                    VStack(spacing: 0) {
                        CustomTextField(placeholder: "Event Name", value: $viewModel.eventName, isRequired: true)
                        
                        ActionTextField(placeholder: "Event Details", value: $viewModel.eventDetails) {
                            viewModel.goToScreen(.details)
                        }
                        
                        ActionTextField(placeholder: "Venue", value: $viewModel.eventVenue) {
                            viewModel.goToScreen(.venue)
                        }
                        
                        ActionTextField(placeholder: "Address", value: $viewModel.eventAddress) {
                            viewModel.goToScreen(.address)
                        }
                    }
                    
                    HStack(alignment: .top) {
                        Image("ic_calendar")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.mainPurple)
                        
                        VStack(alignment: .leading) {
                            Text("Start Date".uppercased())
                                .font(.system(size: 10))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            DatePicker("Start Date", selection: $viewModel.startDate, displayedComponents: .date)
                                .tint(.mainPurple)
                                .background(RoundedRectangle(cornerRadius: 5).fill(.white.opacity(0.3)))
                                .labelsHidden()
                            
                            Text("End Date".uppercased())
                                .font(.system(size: 10))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                                .tint(.mainPurple)
                                .background(RoundedRectangle(cornerRadius: 5).fill(.white.opacity(0.3)))
                                .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        VStack(alignment: .leading) {
                            Text("Start Time".uppercased())
                                .font(.system(size: 10))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            DatePicker("Start Time", selection: $viewModel.startDate, displayedComponents: .hourAndMinute)
                                .tint(.mainPurple)
                                .background(RoundedRectangle(cornerRadius: 5).fill(.white.opacity(0.3)))
                                .labelsHidden()
                            
                            Text("End Time".uppercased())
                                .font(.system(size: 10))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            DatePicker("End Time", selection: $viewModel.endDate, displayedComponents: .hourAndMinute)
                                .tint(.mainPurple)
                                .background(RoundedRectangle(cornerRadius: 5).fill(.white.opacity(0.3)))
                                .labelsHidden()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 8)
                    
                    HStack(alignment: .center) {
                        
                        Image("ic_invite")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.mainPurple)
                        
                        Toggle(isOn: $viewModel.guestsCanInvite, label: {
                            Text("Guests can invite guests")
                                .foregroundStyle(Color.white.opacity(0.5))
                        })
                        .padding(.horizontal)
                        .tint(.mainPurple)
                    }
                    .padding(.vertical, 8)
                    
                    HStack(alignment: .center) {
                        
                        Image("ic_eye")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.mainPurple)
                        
                        Picker("Event Type", selection: $viewModel.eventIsPrivate) {
                            Text("Private").tag(true)
                            Text("Public").tag(false)
                        }
                        .pickerStyle(.segmented)
                        .padding(.leading)
                    }
                    .padding(.vertical, 8)
                    
                    Button(viewModel.isShowingOptions ? "Hide Additional Options" : "Show Additional Options", systemImage: viewModel.isShowingOptions ? "minus" : "plus") {
                        withAnimation {
                            viewModel.isShowingOptions.toggle()
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.top, 8)
                    
                    if viewModel.isShowingOptions {
                        VStack(spacing: 8) {
                            HStack(alignment: .center) {
                                
                                Image("ic_venue")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.mainPurple)
                                
                                ActionTextField(placeholder: "Venue Type", value: $viewModel.venueType) {
                                    viewModel.goToScreen(.venueType)
                                }
                            }
                            
                            HStack(alignment: .center) {
                                
                                Image("ic_music")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.mainPurple)
                                
                                ActionTextField(placeholder: "Music", value: $viewModel.eventMusicString) {
                                    viewModel.goToScreen(.eventMusic)
                                }
                            }
                            
                            HStack(alignment: .center) {
                                
                                Image("ic_crowd")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.mainPurple)
                                
                                ActionTextField(placeholder: "Crowds", value: $viewModel.eventCrowdsString) {
                                    viewModel.goToScreen(.eventCrowds)
                                }
                            }
                            
                            HStack(alignment: .center) {
                                
                                Image("ic_money")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.mainPurple)
                                
                                TextField("", text: $viewModel.minPrice, prompt: Text("Min").foregroundStyle(.white.opacity(0.5)))
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                
                                TextField("", text: $viewModel.maxPrice, prompt: Text("Max").foregroundStyle(.white.opacity(0.5)))
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                    viewModel.setEventIsFree()
                                }, label: {
                                    Text("Free")
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(viewModel.eventIsFree ? .mainPurple : .clear)
                                                .stroke(.white)
                                        )
                                })
                                
                            }
                            
                            HStack(alignment: .center) {
                                
                                Image("ic_tickets")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.mainPurple)
                                
                                CustomTextField(placeholder: "Ticketing URL", value: $viewModel.ticketingUrl)
                            }
                        }
                        .transition(.opacity)
                    }
                    
                    Button("Save Event") {
                        viewModel.saveEvent()
                    }
                    .mainButtonStyle()
                    .padding(.vertical)
                }
                .padding(.horizontal, 24)
                .navigationDestination(isPresented: $viewModel.goToScreen) {
                    switch viewModel.selectedGoToScreen {
                    case .details:
                        LongTextInputView(title: "Event Details", prompt: "Event Details", text: $viewModel.eventDetails)
                    case .venue:
                        VenueSearchView(selectedVenueString: $viewModel.eventVenue, selectedVenue: $viewModel.selectedVenue, viewModel: VenueSearchViewModel())
                    case .address:
                        AddressSearchView(selectedAddress: $viewModel.eventAddress, viewModel: AddressSearchViewModel())
                    case .venueType:
                        ListSelectView(title: "Venue Type", listItems: VenuesType.allCases.map(\.rawValue), selectedItem: $viewModel.venueType)
                    case .eventMusic:
                        TagSelectViewFull(title: "Music", tags: MusicGenre.allValues, selectedTags: $viewModel.eventMusic)
                    case .eventCrowds:
                        TagSelectViewFull(title: "Crowds", tags: ClienteleType.allValues, selectedTags: $viewModel.eventCrowds)
                    case .none:
                        Text("None")
                    }
                }
                .onChange(of: imageItem) {
                    Task {
                        if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                            viewModel.setImage(data: loaded)
                        }
                    }
                }
                .errorAlert(error: $viewModel.error, buttonTitle: "OK")
            }
            .scrollIndicators(.hidden)
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
        
}
