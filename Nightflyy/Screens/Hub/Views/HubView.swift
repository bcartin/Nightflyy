//
//  HubView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 2/3/25.
//

import SwiftUI

struct HubView: View {
    
    @Binding var showMenu: Bool
    @Bindable var viewModel: HubViewModel
    
    var body: some View {
        RouterView {
            VStack(alignment: .leading) {
                
                SegmentedView(segments: viewModel.segments, selected: $viewModel.selectedSegment)
                
                if viewModel.selectedSegment == 1 {
                    UpcomingView()
                }
                else if viewModel.selectedSegment == 2 {
                    HostingView()
                }
                else if viewModel.selectedSegment == 3 {
                    CalendarView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .backgroundImage("slyde_background")
            .background(.backgroundBlack)
            .foregroundStyle(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Events")
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
                        viewModel.navigateToCreateNewEvent()
                    }, label: {
                        Image(systemName:"plus")
                            .foregroundStyle(.white)
                    })
                }
            }
        }
    }
}

#Preview {
    HubView(showMenu: .constant(false), viewModel: HubViewModel())
}
