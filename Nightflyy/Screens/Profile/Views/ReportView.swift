//
//  ReportView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/16/25.
//

import SwiftUI

struct ReportView: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: ReportViewModel
    
    var body: some View {
        VStack {
            Text("Report User")
                .font(.system(size: 18, weight: .bold))
                .padding()
            
            
            Picker("", selection: $viewModel.selectedReason, ) {
                Text("Select a Reason").tag(Optional<String>(nil))
                ForEach(viewModel.reportReasons, id: \.self) {
                    Text($0).tag(Optional($0))
                }
            }
            .pickerStyle(.menu)
            .tint(.white)
            .padding()
            
            TextField("", text: $viewModel.notes, prompt: Text("Notes").foregroundStyle(.white.opacity(0.4)), axis: .vertical)
                .overlay(alignment: .bottom) {
                    Divider()
                        .overlay(Color.white)
                        .offset(y: 8)
                }
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 36)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("CANCEL") {
                    dismiss()
                }
                .padding()
                
                Button("SUBMIT") {
                    viewModel.submitReport()
                    dismiss()
                }
                .foregroundStyle(.white.opacity(viewModel.hasSelectedReason ? 1 : 0.4))
                .padding()
                .disabled(!viewModel.hasSelectedReason)
            }
            .font(.system(size: 21, weight: .bold))
            .padding(.trailing, 36)
            .padding(.bottom, 18)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
}

#Preview {
    ReportView(viewModel: ReportViewModel(objectId: ""))
}
