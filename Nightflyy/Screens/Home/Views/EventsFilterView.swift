//
//  HomeFilterView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/6/24.
//

import SwiftUI

struct EventsFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: EventsFilterViewModel
    @State var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle")
                        .font(.title)
                        .foregroundStyle(.gray)
                }

            }
            
            HStack(spacing: 12) {
                Button {
                    viewModel.selectedFiler = .nearby
                    dismiss()
                } label: {
                    HStack {
                        Image("ic_pin")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.mainPurple)
                        
                        Text("Nearby")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.mainPurple, lineWidth: 1)
                    }
                    
                }
                
                
                Button {
                    viewModel.selectedFiler = .following
                    dismiss()
                } label: {
                    HStack {
                        Image("ic_crowd")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .tint(.mainPurple)
                        
                        Text("Following")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.mainPurple, lineWidth: 1)
                    }
                }

            }
            
            
            Text("POPULAR")
                .font(.system(size: 20, weight: .bold))
            
            Button {
                viewModel.selectCity(name: "Rochester")
                dismiss()
            } label: {
                Text("Rochester, NY")
                    .citySearchResult()
            }

            Button {
                viewModel.selectCity(name: "Syracuse")
                dismiss()
            } label: {
                Text("Syracuse, NY")
                    .citySearchResult()
            }
            
            Text("SEARCH")
                .font(.system(size: 20, weight: .bold))
            
            searchBar
                        
            ScrollView {
                VStack {
                    ForEach(viewModel.filteredCities) { city in
                        Text(city.displayName)
                            .foregroundStyle(.white)
                            .padding(.vertical, 8)
                            .onTapGesture {
                                viewModel.selectCity(city: city)
                                dismiss()
                            }
                        
                        Divider().background(.white)
                    }
                }
            }
            
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundBlack)
        .onChange(of: searchText) { oldValue, newValue in
            viewModel.filterCities(filterText: newValue)
        }
    }
    
    var searchBar: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("", text: $searchText, prompt: Text("Search").foregroundStyle(.gray))
                .foregroundStyle(.white)
                .font(Font.system(size: 21))
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(7)
        .background(Color.black.brightness(0.2))
        .cornerRadius(12)
    }
}

//#Preview {
//    HomeFilterView(viewModel: .constant(.init()))
//}
