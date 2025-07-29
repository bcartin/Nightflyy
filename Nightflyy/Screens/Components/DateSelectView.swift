//
//  DateSelectView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/10/25.
//

import SwiftUI

struct DateSelectView: View {
    var title: String
    @Binding var selectedDate: Date
    
    var body: some View {
        
        VStack {
            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxHeight: 400)
                .tint(.mainPurple)
                .colorScheme(.dark)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
        .foregroundStyle(.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    DateSelectView(title: "Date of Birth", selectedDate: .constant(Date()))
}
