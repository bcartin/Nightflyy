//
//  SignUpView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/24/24.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {

    @Environment(AuthenticationManager.self) private var authenticationManager
    @Binding var flip: Bool
    @Binding var viewModel: SignupViewModel
    
    var body: some View {
        
            ZStack {
                SliderView()
                
                VStack {
                    Image("banner")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 36)
                        .padding(.top, 64)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.setSignupMethod(.nightflyy)
                        viewModel.goToScreen(.account)
                    }, label: {
                        Label(
                            title: { Text("Sign Up with Nightflyy").foregroundStyle(.white) },
                            icon: { Image("slyde_fly").renderingMode(.template).resizable().scaledToFit().frame(width: 36, height: 36).tint(.white).padding(.vertical, -8).padding(.horizontal, -4) }
                        )
                        .mainButtonStyle()
                    })
                    
                    SignInWithAppleButton(.signUp) { request in
                        request.requestedScopes = [.email, .fullName]
                        request.nonce = authenticationManager.sha256(viewModel.nonce)
                    } onCompletion: { result in
                        switch result {
                            
                        case .success(let authorization):
                            viewModel.setSignupMethod(.apple)
                            viewModel.appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
                            viewModel.setValuesFromAppleCredential()
                            viewModel.goToScreen(.profile)
                        case .failure(let error):
                            viewModel.error = error
                        }
                    }
                    .overlay {
                        ZStack {
                            Capsule()
                                .fill(.appleBlack.gradient)
                            
                            HStack(spacing: 18) {
                                Image(systemName: "applelogo")
                                
                                Text("Sign Up with Apple")
                            }
                            .foregroundStyle(.white)
                        }
                        .allowsHitTesting(false)
                    }
                    .frame(height: 50)
                    .clipShape(.capsule)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                    
                    HStack {
                        Text("Have an account?")
                            .foregroundStyle(.white)
                        
                        Button("Log In") {
                            withAnimation {
                                flip.toggle()
                            }
                        }
                        .foregroundStyle(.mainPurple)
                    }
                    .padding()
                    .padding(.bottom, 44)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundBlack)
            
    }
}

#Preview {
    SignUpView(flip: .constant(true), viewModel: .constant(SignupViewModel()))
}
