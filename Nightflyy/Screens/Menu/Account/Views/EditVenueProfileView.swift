//
//  EditVenueProfileView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/23/25.
//

import SwiftUI
import PhotosUI

struct EditVenueProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(ToastsManager.self) private var toastsManager
    @Bindable var viewModel: EditVenueProfileViewModel
    @State var imageItem: PhotosPickerItem?
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        NavigationStack {
            
            ZStack {
                
                ScrollView(.vertical) {
                    
                    PhotosPicker(selection: $imageItem, matching: .images) {
                        ZStack {
                            Circle()
                                .fill(.mainPurple.gradient)
                                .frame(width: 100, height: 100)
                            
                            if let image = viewModel.selectedImage {
                                image
                                    .resizable()
                                    .frame(width: 94, height: 94)
                                    .clipShape(Circle())
                            }
                            else if let profileImageUrl = viewModel.account.profileImageUrl {
                                CachedAsyncImage(url: URL(string: profileImageUrl), size: .init(width: 94, height: 94), shape: .circle)
                            }
                            else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 94, height: 94)
                                    .clipShape(Circle())
                                
                            }
                            
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .background(.white)
                                .foregroundStyle(.mainPurple.gradient)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                                .offset(x: 40, y: -35)
                        }
                        .padding(.vertical)
                    }
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Text("Account Info".uppercased())
                                .font(.system(size: 15, weight: .bold))
                            
                            CustomTextField(placeholder: "Username", value: $viewModel.username, keyboardType: .URL, isRequired: true)
                            
                            CustomTextField(placeholder: "Email", value: $viewModel.email, keyboardType: .URL, disabled: true)
                            
                            ZStack(alignment: .trailing) {
                                CustomSecureTextField(placeholder: "Password", value: $viewModel.password, disabled: true)
                                
                                Button("Change") {
                                    viewModel.goToScreen(.changePassword)
                                }
                                .foregroundStyle(.white)
                                .font(.system(size: 13, weight: .medium))
                            }
                            
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading) {
                            Text("Venue Info".uppercased())
                                .font(.system(size: 15, weight: .bold))
                            
                            CustomTextField(placeholder: "Name", value: $viewModel.name, isRequired: true)
                            ActionTextField(placeholder: "Venue Type", value: $viewModel.venueType) {
                                viewModel.goToScreen(.venueType)
                            }
                            ActionTextField(placeholder: "Address", value: $viewModel.address) {
                                viewModel.goToScreen(.address)
                            }
                            ActionTextField(placeholder: "Description", value: $viewModel.bio) {
                                viewModel.goToScreen(.bio)
                            }
                            CustomTextField(placeholder: "Phone Number", value: $viewModel.phoneNumber, isRequired: true)
                            CustomTextField(placeholder: "Business Email", value: $viewModel.businessEmail, isRequired: true)
                            CustomTextField(placeholder: "Website", value: $viewModel.website)
                        }
                        
                    }
                    .padding(.horizontal, 24)
                    .foregroundStyle(.white)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .backgroundImage("slyde_background")
                .background(.backgroundBlack)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.saveChanges()
                        } label: {
                            Text("Save")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Edit Info")
                            .foregroundStyle(.white)
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .onChange(of: imageItem) {
                Task {
                    if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                        viewModel.setImage(data: loaded)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.goToScreen) {
                switch viewModel.selectedGoToScreen {
                case .venueType:
                    ListSelectView(title: "Venue Type", listItems: VenuesType.allCases.map(\.rawValue), selectedItem: $viewModel.venueType)
                case .bio:
                    LongTextInputView(title: "Description", prompt: "Type your venue's description here", text: $viewModel.bio)
                case .changePassword:
                    ChangePasswordView(viewModel: ChangePasswordViewModel())
                case .address:
                    AddressSearchView(selectedAddress: $viewModel.address, viewModel: AddressSearchViewModel())
                case .none:
                    Text("None")
                }
                
                
                
            }
            .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        }
        .tint(.white)
        .interactiveToast($toastsManager.toasts)
    }
}
