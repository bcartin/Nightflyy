//
//  LoginView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/24/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @Environment(AuthenticationManager.self) private var authenticationManager
    @State var viewModel = LoginViewModel()
    @Binding var flip: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image("banner")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 42)
                .padding(.bottom, 56)
            
            VStack(spacing: 16) {
                TextField("", text: $viewModel.email, prompt: Text("Email").foregroundStyle(.white.opacity(0.5)))
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.mainPurple, lineWidth: 0.5)
                    )
                    .padding(.horizontal, 32)
                
                SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundStyle(.white.opacity(0.5)))
                    .font(.title3)
                    .foregroundStyle(.white)
                
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.mainPurple, lineWidth: 0.5)
                    )
                    .padding(.horizontal, 32)
                
                HStack{
                    Spacer()
                    Text("Forgot your password?")
                        .foregroundStyle(.white)
                        .font(.footnote)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 32)
                
            }
            .padding(.bottom, 48)
            
            Button(action: {
                viewModel.logInWithEmail()
            }, label: {
                Text("Log In")
                    .mainButtonStyle()
            })
            
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.email, .fullName]
                request.nonce = authenticationManager.sha256(viewModel.nonce)
            } onCompletion: { result in
                switch result {
                    
                case .success(let authorization):
                    viewModel.appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
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
                        
                        Text("Continue with Apple")
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
                Text("Don't have an account?")
                    .foregroundStyle(.white)
                
                Button("Sign Up") {
                    withAnimation {
                        flip.toggle()
                    }
                }
                .foregroundStyle(.mainPurple)
            }
            .padding()
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .errorAlert(error: $viewModel.error)
    }
}

#Preview {
    LoginView(flip: .constant(true))
}
