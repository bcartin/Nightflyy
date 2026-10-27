//
//  SignUpPaywall.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/22/25.
//

import SwiftUI

struct SignUpPaywall: View {

    @Binding var viewModel: SignupViewModel

    var body: some View {
        NFPContainerView()
            .navigationBarBackButtonHidden()
            .background(.backgroundBlack)
    }
}

#Preview {
    SignUpPaywall(viewModel: .constant(SignupViewModel()))
}
