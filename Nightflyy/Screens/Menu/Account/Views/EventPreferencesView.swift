//
//  EventPreferencesView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/11/25.
//

import SwiftUI

struct EventPreferencesView: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: EventPreferencesViewModel
    @Environment(ToastsManager.self) private var toastsManager
    
    var body: some View {
        @Bindable var toastsManager = toastsManager
        
        NavigationStack {
            ZStack {
                VStack {
                    
                    SegmentedView(segments: viewModel.segments, selected: $viewModel.selectedSegment)
                    
                    if viewModel.selectedSegment == 1 {
                        TagSelectView(tags: MusicGenre.allValues, selectedTags: $viewModel.selectedMusic)
                    }
                    else if viewModel.selectedSegment == 2 {
                        TagSelectView(tags: ClienteleType.allValues, selectedTags: $viewModel.selectedClientele)
                    }
                    else if viewModel.selectedSegment == 3 {
                        TagSelectView(tags: VenuesType.allValues, selectedTags: $viewModel.selectedVenues)
                    }
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .backgroundImage("slyde_background")
                .background(.backgroundBlack)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.saveChanges()
                        } label: {
                            Text("Save")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Edit Event Preferences")
                            .foregroundStyle(.white)
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .errorAlert(error: $viewModel.error, buttonTitle: "OK")
        }
        .tint(.white)
        .interactiveToast($toastsManager.toasts)
    }
}

#Preview {
    EventPreferencesView(viewModel: EventPreferencesViewModel())
}
