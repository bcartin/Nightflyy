//
//  SegmentedView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 11/18/24.
//

import SwiftUI

struct SegmentedViewOption: Identifiable {
    
    var id: Int
    var title: String
    
}

struct SegmentedView: View {

    let segments: [SegmentedViewOption]
    @Binding var selected: Int
    @Namespace var name
    @State var isDisabled: Bool = false

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments) { segment in
                Button {
                    if selected != segment.id {
                        disableButtons()
                        withAnimation {
                            selected = segment.id
                        }
                    }
                } label: {
                    VStack {
                        Text(segment.title)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(selected == segment.id ? .mainPurple : Color(uiColor: .systemGray))
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if selected == segment.id {
                                Capsule()
                                    .fill(.mainPurple)
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                    .padding(.top, 12)
                }
                .disabled(isDisabled)
            }
        }
    }
    
    
    func disableButtons() {
        isDisabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.isDisabled = false
        }
    }
}

#Preview {
    SegmentedView(segments: [SegmentedViewOption(id: 1, title: "Following"), SegmentedViewOption(id: 2, title: "Followers")], selected: .constant(1))
        .preferredColorScheme(.dark)
}
