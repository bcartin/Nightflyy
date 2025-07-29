//
//  CalendarView.swift
//  Nightflyy
//
//  Created by Bernie Cartin on 4/7/25.
//

import SwiftUI

struct CalendarView: View {
    
    @State var currentMonth: Int = 0
    @Bindable var viewModel: CalendarViewModel = .init()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                // Separate to other view
                VStack(spacing: 20) {
                    
                    let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(extractDate()[0])
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            Text(extractDate()[1])
                                .font(.title.bold())
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button {
                            withAnimation {
                                currentMonth -= 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundStyle(.mainPurple)
                        }

                        Button {
                            withAnimation {
                                currentMonth += 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundStyle(.mainPurple)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 0) {
                        ForEach(days, id: \.self) { day in
                                Text(day)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    let colums = Array(repeating: GridItem(.flexible()), count: 7)
                                       
                    LazyVGrid(columns: colums, spacing: 0) {
                        ForEach(extractDates()) { value in
                            CardView(value: value)
                                .background(
                                    Capsule()
                                        .fill(.mainPurple)
                                        .padding(.horizontal, 8)
                                        .opacity(value.date.isSameDay(as: viewModel.selectedDate) ? 1 : 0)
                                        .offset(y: -8)
                                )
                                .onTapGesture {
                                    viewModel.selectedDate = value.date
                                }
                        }
                    }
                    
                    if viewModel.hasEventsForSelectedDay {
                        ScrollView {
                            ForEach(viewModel.selectedDayEvents, id: \.self) { viewModel in
                                EventListItemView(viewModel: viewModel) {
                                    viewModel.navigateToEvent()
                                }
                                .padding(.horizontal, 12)
                            }

                        }
                    }
                    else {
                        VStack {
                            Spacer()
                            Text("No Events")
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                }
                .onChange(of: currentMonth) {
                    viewModel.selectedDate = getCurrentMonth()
                }
                
            }
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack(spacing: 4) {
            if value.day != -1 {
                Text("\(value.day)")
                    .foregroundStyle(value.date.isSameDay(as: .now) ? value.date.isSameDay(as: viewModel.selectedDate) ? .white : .mainPurple : .white)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                
                if viewModel.events.first(where: { event in
                    return event.startDate!.isSameDay(as: value.date)
                }) != nil {
                    
                    Circle()
                        .fill(value.date.isSameDay(as: viewModel.selectedDate) ? .white : .mainPurple)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.vertical, 0)
        .frame(height: 50, alignment: .top)
    }
    
    func extractDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: viewModel.selectedDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    func extractDates() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<(firstWeekday - 1) {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
        
    }
}

#Preview {
    CalendarView()
        .preferredColorScheme(.dark)
}

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
