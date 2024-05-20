//
//  InboxView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/22/24.
//

import SwiftUI

struct InboxView: View {
    
    @Binding var showMenu: Bool
    @State private var searchText = ""
    
    var body: some View {
        RouterView {
            ScrollView {
                
            }
            .frame(maxWidth: .infinity)
            .background(.backgroundBlack)
            .safeAreaPadding(.bottom, 44)
            .foregroundStyle(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Inbox")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }, label: {
                        Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                            .foregroundStyle(.white)
                            .contentTransition(.symbolEffect)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {

                    }, label: {
                        Image(systemName:"square.and.pencil")
                            .foregroundStyle(.white)
                    })
                }
            }
        }
        .scrollIndicators(.hidden)
        .searchable(text: $searchText, prompt: "Search")
    }
}

#Preview {
    InboxView(showMenu: .constant(false))
}
