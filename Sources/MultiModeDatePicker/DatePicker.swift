//
//  DatePicker.swift
//  Enjay CRM
//
//  Created by MacBook Pro on 18/09/25.
//  Copyright © 2025 Enjay It Solutions Ltd. All rights reserved.
//

import Foundation
import SwiftUI

public struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding private var selectedDate: Date
    private let minDate: Date?
    private let maxDate: Date?
    private let title: String
    private let pickerStyle: CustomPickerType
    private let timeSystem: TimeSystem
    
    public init(
        initialDate: Date = Date(),
        selectedDate: Binding<Date>,
        minDate: Date?,
        maxDate: Date?,
        title: String = "Select Date",
        timeSystem: TimeSystem,
        pickerStyle: CustomPickerType
    ){
       
        self._selectedDate = selectedDate
        self.minDate = minDate
        self.maxDate = maxDate
        self.title = title
        self.timeSystem = timeSystem
        self.pickerStyle = pickerStyle
    }
    
    public var body: some View {
        ZStack {
            
                Group {
                    switch pickerStyle {
                    case .date:
                        DatePicker("", selection: $selectedDate,in: (minDate ?? Date.distantPast)...(maxDate ?? Date.distantFuture),displayedComponents:[.date]).datePickerStyle(.graphical)
                    case .dateTime:
                        DatePicker("" , selection: $selectedDate , in: (minDate ?? Date.distantPast)...(maxDate ?? Date.distantFuture),
                        displayedComponents: [.date, .hourAndMinute]
                        )
                        .environment(\.locale , getTimeSystem(timeSystem: timeSystem))
                        .datePickerStyle(.graphical)
                    case .monthDay:
                        MonthDayPicker(date: $selectedDate)
                    case .year:
                        YearPicker(date: $selectedDate)
                    case .yearMonth:
                        YearMonthPicker(date: $selectedDate)
                    case .time:
                        DatePicker("" , selection: $selectedDate , in: (minDate ?? Date.distantPast)...(maxDate ?? Date.distantFuture),
                                   displayedComponents: [.hourAndMinute]
                        )
                        .environment(\.locale , getTimeSystem(timeSystem: timeSystem))
                        .datePickerStyle(.wheel)
                        .frame(maxWidth: 200)

                    }
                }
                .labelsHidden()
            
                
        }
        .cornerRadius(16)
        .padding(.horizontal , 24)
        
    }
    
    func getTimeSystem(timeSystem: TimeSystem)-> Locale{
        switch timeSystem {
        case .tweleHours:
            return Locale(identifier: "en_US")
            
        case .twentyFourHours:
            return Locale(identifier: "en_GB")
        }
    }
}


struct MonthDayPicker: View {
    @Binding var date: Date
    private var months: [String] {
        DateFormatter().monthSymbols
    }
    private var days: [Int] {
        Array(1...31)
    }
    
    
    var body: some View {
        HStack {
            Picker("Month", selection: Binding(
                get: {
                    Calendar.current.component(.month, from: date) - 1
                },
                set: { newValue in
                    update(month: newValue + 1)
                }
            )){
                ForEach(0..<months.count, id: \.self) { index in
                    Text(months[index]).tag(index)
                }
            }
            
            Picker("Day" ,selection: Binding(
                get: {
                    Calendar.current.component(.day, from: date)
                }, set: { newValue in
                    update(day: newValue)
                }
            )){
                ForEach(days , id: \.self) { day in
                    Text("\(day)").tag(day)
                }
            }
        }
        .pickerStyle(.wheel)
    }
    
    private func update(month: Int? = nil, day: Int? = nil){
        var component = Calendar.current.dateComponents([.year , .month , .day], from: date)
        if let month = month {component.month  = month}
        if let day = day {component.day = day}
        date =  Calendar.current.date(from: component) ?? date
    }
}


struct YearPicker: View {
    @Binding var date: Date
    
    private var years: [Int] {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current-100)...(current+20))
    }
    
    var body: some View {
        Picker("Year", selection: Binding(
            get: { Calendar.current.component(.year, from: date) },
            set: { newYear in
                var comp = Calendar.current.dateComponents([.year, .month, .day], from: date)
                comp.year = newYear
                date = Calendar.current.date(from: comp) ?? date
            })) {
                ForEach(years, id: \.self) { y in
                    Text(String(y)).tag(y)
                }
        }
        .pickerStyle(.wheel)
    }
}

struct YearMonthPicker: View {
    @Binding var date: Date
    
    private var months: [String] {
        DateFormatter().monthSymbols
    }
    private var years: [Int] {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current-100)...(current+20))
    }
    
    var body: some View {
        HStack {
            
            Picker("Month", selection: Binding(
                get: { Calendar.current.component(.month, from: date) - 1 },
                set: { newMonth in
                    update(month: newMonth + 1)
                })) {
                    ForEach(0..<months.count, id: \.self) { i in
                        Text(months[i]).tag(i)
                    }
                }
            
            Picker("Year", selection: Binding(
                get: { Calendar.current.component(.year, from: date) },
                set: { newYear in
                    update(year: newYear)
                })) {
                    ForEach(years, id: \.self) { y in
                        Text(String(y)).tag(y)
                    }
                }
        }
        .pickerStyle(.wheel)
    }
    
    private func update(year: Int? = nil, month: Int? = nil) {
        var comp = Calendar.current.dateComponents([.year, .month, .day], from: date)
        if let y = year { comp.year = y }
        if let m = month { comp.month = m }
        date = Calendar.current.date(from: comp) ?? date
        
    }
}
