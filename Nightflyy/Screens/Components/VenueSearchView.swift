//
//  VenueSearchView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/28/25.
//

import SwiftUI

struct VenueSearchView: View {
    
    @Binding var selectedVenueString: String
    @Binding var selectedVenue: Account?
    @State var isTyping: Bool = false
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFieldFocused: Bool
    
    @ObservedObject var viewModel: VenueSearchViewModel
    
    var body: some View {
            VStack(spacing: 20) {
                
                TextField("", text: $viewModel.searchText, prompt: Text("Venue").foregroundStyle(.white.opacity(0.5)))
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
                
                if !viewModel.searchText.isEmpty {
                    HStack {
                        (Text("Use: ") + Text(viewModel.searchText))
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        selectedVenueString = viewModel.searchText
                        dismiss()
                    }
                }
                
                
                ScrollView(.vertical) {
                    VStack {
                        ForEach(viewModel.venueSearchResults) { venue in
                            VenueListItemView(viewModel: VenueListItemViewModel(venue: venue)) {
                                    selectedVenue = venue
                                    selectedVenueString = venue.name ?? ""
                                    dismiss()
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top)
                .scrollIndicators(.hidden)
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
                    Text("Venue")
                        .foregroundStyle(.white)
                }
            }
            .onAppear {
                isFieldFocused = true
                isTyping = true
            }
    }
}
