//
//  DateFilterView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 6/16/25.
//

import SwiftUI

struct DateFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date?
    @State var displayDate: Date = .now
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Date")
                .foregroundStyle(.white)
                .font(.system(size: 21, weight: .bold))
                .padding()
                .padding(.bottom, 18)
            
            VStack(alignment: .leading) {
                Text(displayDate.stringValue(format: "yyyy"))
                    .foregroundStyle(.gray)
                    .font(.system(size: 24, weight: .bold))
                Text(displayDate.stringValue(format: "EEE, MMM dd"))
                    .foregroundStyle(.white)
                    .font(.system(size: 32, weight: .bold))
            }
            .padding(.trailing, 180)
            
            DatePicker("", selection: $displayDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxHeight: 400)
                .colorScheme(.dark)
                .tint(.mainPurple)
                .padding(.top, -12)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("CANCEL") {
                    selectedDate = nil
                    dismiss()
                }
                .padding()
                
                Button("OK") {
                    selectedDate = displayDate
                    dismiss()
                }
                .padding()
            }
            .foregroundStyle(.white)
            .font(.system(size: 21, weight: .bold))
            .padding(.trailing, 36)
            .padding(.bottom, 18)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .backgroundImage("slyde_background")
        .background(.backgroundBlack)
    }
}

#Preview {
    DateFilterView(selectedDate: .constant(nil))
}
