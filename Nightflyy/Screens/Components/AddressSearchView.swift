//
//  AddressSearchView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/23/25.
//

import SwiftUI

struct AddressSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var isTyping: Bool = false
    @Binding var selectedAddress: String
    @ObservedObject var viewModel: AddressSearchViewModel
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        VStack {
            TextField("", text: $viewModel.searchText, prompt: Text("Address").foregroundStyle(.white.opacity(0.5)))
                .foregroundStyle(.white)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focused($isFieldFocused)
                .onTapGesture {
                    self.isTyping = true
                }
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white.opacity(0.5))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isTyping {
                            Button(action: {
                                viewModel.searchText = ""
                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundStyle(.gray)
                                    .padding(.trailing, 12)
                            })
                        }
                    }
                }
            
            ScrollView {
                ForEach(viewModel.searchResults, id: \.self) { result in
                    Button {
                        Task { @MainActor in
                            await viewModel.selectAddress(result: result)
                            self.selectedAddress = viewModel.selectedAddress
                            dismiss()
                        }
                    } label: {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                Text(result.subtitle)
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                
                                Divider()
                                    .overlay(.white.opacity(0.3))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(12)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .scrollDismissesKeyboard(.interactively)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Address")
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            isFieldFocused = true
            isTyping = true
        }
        
    }
}

//#Preview {
//    AddressSearchView(selectedAddress: .constant(""), viewModel: AddressSearchViewModel())
//}
