//
//  SU_ProfileView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/22/25.
//

import SwiftUI
import PhotosUI

struct SU_ProfileView: View {
    @Binding var viewModel: SignupViewModel
    @State var imageItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 12) {
            
            Text("Let's make your profile!")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom)
            
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
            }
            
            Text("Upload profile picture")
                .foregroundStyle(.gray)
                .font(.system(size: 11))
            
            CustomTextField(placeholder: "Username", value: $viewModel.username, keyboardType: .URL, isRequired: true)
            
            CustomTextField(placeholder: "Name", value: $viewModel.name, isRequired: true)
            
            ActionTextField(placeholder: "Gender", value: $viewModel.gender, isRequired: true) {
                viewModel.goToScreen(.gender)
            }
            
            ActionTextField(placeholder: "Date of Birth", value: $viewModel.dob, isRequired: true) {
                viewModel.goToScreen(.dob)
            }
            
            Spacer()
            
            Button("Signup") {
                Task {
                    await viewModel.signUp()
                }
            }
            .mainButtonStyle()
            
            VStack(spacing: 4) {
                Text("By signing up you agree to our")
                    .font(.system(size: 10))
                
                HStack {
                    Text("Terms of Service")
                        .font(.system(size: 10))
                        .foregroundStyle(.mainPurple)
                        .onTapGesture {
                            viewModel.presentSheet(.terms)
                        }
                    
                    Text("and")
                        .font(.system(size: 10))
                    
                    Text("Privacy Policy")
                        .font(.system(size: 10))
                        .foregroundStyle(.mainPurple)
                        .onTapGesture {
                            viewModel.presentSheet(.privacy)
                        }
                }
            }
            .errorAlert(error: $viewModel.error, buttonTitle: "OK")
            .onChange(of: imageItem) {
                Task {
                    if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                        viewModel.setImage(data: loaded)
                    }
                }
            }
            .sheet(isPresented: $viewModel.presentSheet, content: {
                switch viewModel.sheetView {
                case .terms:
                    MenuItem.termsOfService.associatedView
                case .privacy:
                    MenuItem.privacyPolicy.associatedView
                case .none:
                    EmptyView()
                }
            })
        }
        .ignoresSafeArea()
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
}

#Preview {
    SU_ProfileView(viewModel: .constant(SignupViewModel()))
}
