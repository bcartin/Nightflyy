//
//  EventCommentsView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/25/25.
//

import SwiftUI

struct EventCommentsListView: View {
    
    @Bindable var viewModel: EventViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                Text("Comments")
                    .font(.system(size: 14, weight: .medium))
                    .padding(18)
                
                ForEach(viewModel.commentsViewModels, id: \.self) { viewModel in
                    LazyVStack {
                        EventCommentView(viewModel: viewModel)
                            .task {
                                await viewModel.fetchAccount()
                            }
                    }
                }
            }
            
            HStack(alignment: .top) {
                TextField("", text: $viewModel.commentText, prompt: Text("Comment").foregroundStyle(.gray.opacity(0.5)), axis: .vertical)
                    .padding()
                    .multilineTextAlignment(.leading)
                
                Button(action: {
                    viewModel.saveComment()
                }, label: {
                    Image("ic_send")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.mainPurple)
                        .padding(.trailing)
                        .padding(.vertical)
                })
                .disabled(viewModel.commentText.isEmpty)
            }
            .frame(minHeight: 44)
            .background(.backgroundBlack)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .scrollIndicators(.hidden)
//        .errorAlert(error: $viewModel.error, buttonTitle: "OK")
    }
}

//#Preview {
//    EventCommentsView(viewModel: .constant(EventViewModel(event: Event())))
//}
