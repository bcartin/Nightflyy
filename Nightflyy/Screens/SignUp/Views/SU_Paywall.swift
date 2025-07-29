//
//  SU_Paywall.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 5/22/25.
//

import SwiftUI

struct SU_Paywall: View {
    
    @Binding var viewModel: SignupViewModel
    
    var body: some View {
        NFPContainerView()
            .navigationBarBackButtonHidden()
            .background(.backgroundBlack)
    }
}

#Preview {
    SU_Paywall(viewModel: .constant(SignupViewModel()))
}
