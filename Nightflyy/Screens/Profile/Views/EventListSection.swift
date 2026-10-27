//
//  EventListSection.swift
//  Nightflyy
//

import SwiftUI

/// A titled list of events on a profile, with an empty state. Tapping an event opens it.
struct EventListSection: View {

    let header: String
    let viewModels: [EventListItemViewModel]
    /// Font for the header; `nil` keeps the inherited font.
    var headerFont: Font?

    var body: some View {
        VStack(alignment: .leading) {
            Text(header.uppercased())
                .font(headerFont)
                .foregroundStyle(.white)
                .fontWeight(.medium)

            if viewModels.isEmpty {
                Text("No Events")
                    .foregroundStyle(.gray)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(viewModels, id: \.self) { viewModel in
                    LazyVStack {
                        EventListItemView(viewModel: viewModel) {
                            viewModel.navigateToEvent()
                        }
                        .task {
                            await viewModel.fetchOwner()
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 12)
    }
}
