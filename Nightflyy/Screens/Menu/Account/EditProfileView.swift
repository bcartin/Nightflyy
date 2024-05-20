//
//  EditProfileView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/8/25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(ToastsManager.self) private var toastsManager
    @Bindable var viewModel: EditProfileViewModel
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
                                AsyncImage(url: URL(string: profileImageUrl)) { image in
                                    image.image?.resizable()
                                }
                                .frame(width: 94, height: 94)
                                .clipShape(Circle())
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
                            
                            CustomTextField(placeholder: "Username", value: $viewModel.username, keyboardType: .URL)
                            
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
                            Text("Personal Info".uppercased())
                                .font(.system(size: 15, weight: .bold))
                            
                            CustomTextField(placeholder: "Name", value: $viewModel.name)
                            
                            ActionTextField(placeholder: "Gender", value: $viewModel.gender) {
                                viewModel.goToScreen(.gender)
                            }
                            
                            ActionTextField(placeholder: "Date of Birth", value: $viewModel.dob) {
                                viewModel.goToScreen(.dob)
                            }
                            
                            ActionTextField(placeholder: "Bio", value: $viewModel.bio) {
                                viewModel.goToScreen(.bio)
                            }
                            
                            CustomTextField(placeholder: "Current City (optional)", value: $viewModel.currentCity)
                            
                            CustomTextField(placeholder: "Phone Number (optional)", value: $viewModel.phoneNumber)
                            
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
                case .gender:
                    ListSelectView(title: "Gender", listItems: Gender.allCases.map(\.rawValue), selectedItem: $viewModel.gender)
                case .dob:
                    DateSelectView(title: "Date of Birth", selectedDate: $viewModel.convertedDob)
                case .bio:
                    LongTextInputView(title: "Bio", prompt: "Type your bio", text: $viewModel.bio)
                case .changePassword:
                    ChangePasswordView(viewModel: ChangePasswordViewModel())
                case .none:
                    Text("None")
                }
                
                
                
            }
            .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        }
        .tint(.white)
        .interactiveToast($toastsManager.toasts)
        
        // EXMPLE of SYSTEM TRAY
//        .systemTrayView($viewModel.showSelectGenderView) {
//            VStack(spacing: 20) {
//                SelectGenderTrayView(selectedGender: $viewModel.gender, showSelectGenderView: $viewModel.showSelectGenderView)
//            }
//            .padding(24)
//        }
    }
    
}

//#Preview {
//    EditProfileView()
//        .preferredColorScheme(.dark)
//}
