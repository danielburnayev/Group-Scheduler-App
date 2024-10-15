//
//  File.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/1/24.
//

import Foundation
import SwiftUI

struct ScheduleView: View {
    
    @State var ID: String
    @State var mainScreen: ContentView
    @State private var leaveSchedule: Bool = false
    @State private var twelveHourTime: Bool = true
    @State private var timeTypeTitle: String = "12 HR TIME"
    @State private var present: SchedulePresentOption = .Week
    @State private var observedDate: Date = Date()
    @State private var displayButtonColors: [[Color]] =
    [[Color.white, Color.blue],
     [Color.blue, Color.white],
     [Color.white, Color.blue]]
    
    var body : some View {
        if (!leaveSchedule) {
            HStack {
                Button("Day") {
                    present = .Day
                    turnOnDisplayButton(buttonIndex: 0)
                    turnOffDisplayButton(buttonIndex: 1)
                    turnOffDisplayButton(buttonIndex: 2)
                }
                .padding(5)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(3.0)
                .background(displayButtonColors[0][0])
                .foregroundColor(displayButtonColors[0][1])
                
                Button("Week") {
                    present = .Week
                    turnOnDisplayButton(buttonIndex: 1)
                    turnOffDisplayButton(buttonIndex: 0)
                    turnOffDisplayButton(buttonIndex: 2)
                }
                .padding(5)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(3.0)
                .background(displayButtonColors[1][0])
                .foregroundColor(displayButtonColors[1][1])
                
                Button("Month") {
                    present = .Month
                    turnOnDisplayButton(buttonIndex: 2)
                    turnOffDisplayButton(buttonIndex: 0)
                    turnOffDisplayButton(buttonIndex: 1)
                }
                .padding(5)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(3.0)
                .background(displayButtonColors[2][0])
                .foregroundColor(displayButtonColors[2][1])
                
                if (present != .Month) {
                    Toggle(timeTypeTitle, isOn:$twelveHourTime)
                        .toggleStyle(.button)
                        .onChange(of: twelveHourTime) {
                            timeTypeTitle =
                            ((twelveHourTime) ? "12" : "24") + " HR TIME"
                        }
                }
                
                Text("ID: \(ID)")
                    .bold()
            }
            .padding(.leading, 5.0)
            .frame(maxWidth: .infinity,
                   maxHeight: 40,
                   alignment: .leading)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            
            
            VStack {
                HStack {
                    displayTimeRangeHeader(date: observedDate)
                }
                
                HStack {
                    displayWeekdayText(date: observedDate)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        createCalenderDisplay(date: observedDate)
                    }
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)
                
                HStack {
                    Button("Back to main") {
                        leaveSchedule = true
                        mainScreen.showSchedule = false
                        
                    } //replace with a pull-up menu
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    
                    Button("Demo button") {
                        print("Display demo days")
                    }
                    .border(Color.black, width: 1)
                }
                .frame(maxWidth: .infinity,
                       maxHeight: 30)
                .border(Color.black, width: 1)
            }
        }
        else {
            mainScreen
        }
    }
    
    func getCorrespondingButtonText() -> [String] {
        switch present {
        case .Day:
            return ["Yesterday", "Tommorow"]
        case .Month:
            return ["Last Month", "Next Month"]
        case .Week:
            return ["Last Week", "Next Week"]
        }
    }
    
    func getCorrespondingDayTitle(date: Date) -> String {
        switch present {
        case .Day:
            return date.formatted(
                Date.FormatStyle()
                    .month(.wide)
                    .day()
                    .year()
            )
        case .Month:
            return date.formatted(
                Date.FormatStyle()
                    .month(.wide)
                    .year()
            )
        case .Week:
            let startDay =
                startOfWeek(date: date)
                    .formatted(
                        Date.FormatStyle()
                            .month(.wide)
                            .day()
                    )
            
            let endDay =
                endOfWeek(date: date)
                    .formatted(
                        Date.FormatStyle()
                            .month(.wide)
                            .day()
                    )
            
            return "\(startDay) – \(endDay)"
        }
    }
    
    func getYearNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().year()
        )) ?? 0
    }
    
    func getMonthNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().month(.twoDigits)
        )) ?? 0
    }
    
    func getWeekDayNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().weekday(.oneDigit)
        )) ?? 0
    }
    
    func getWeekNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().week(.weekOfMonth)
        )) ?? 0
    }
    
    func getDayNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().day()
        )) ?? 0
    }
    
    func startOfWeek(date: Date) -> Date {
        return date - (86400 * (getWeekDayNum(date: date) - 1))
    }
    
    func endOfWeek(date: Date) -> Date {
        return date + (86400 * (7 - getWeekDayNum(date: date)))
    }
    
    func lastDayOfMonth(date: Date) -> Date {
        let dayNum = Int(getDayNum(date: date))
        var supposedLastDay = date + Double(86400 * (28 - dayNum))
        
        for maxDays in 29...31 {
            if (getMonthNum(date: supposedLastDay + 86400) != getMonthNum(date: date)) {break}
            supposedLastDay = date + Double(86400 * (maxDays - dayNum))
        }
        return supposedLastDay
    }
    
    func compareDays(date1: Date, date2: Date) -> Bool {
        return getYearNum(date: date1) == getYearNum(date: date2) &&
        getMonthNum(date: date1) == getMonthNum(date: date2) &&
        getDayNum(date: date1) == getDayNum(date: date2)
    }
    
    func turnOnDisplayButton(buttonIndex: Int) {
        displayButtonColors[buttonIndex][0] = Color.blue
        displayButtonColors[buttonIndex][1] = Color.white
    }
    
    func turnOffDisplayButton(buttonIndex: Int) {
        displayButtonColors[buttonIndex][0] = Color.white
        displayButtonColors[buttonIndex][1] = Color.blue
    }
    
    @ViewBuilder func displayTimeRangeHeader(date: Date) -> some View {
        let buttonNames = getCorrespondingButtonText()
        Button(buttonNames[0]) {
            switch present {
            case .Day:
                observedDate -= 86400
            case .Month:
                //moes the day to the last day of the previous month
                observedDate -= 86400 * getDayNum(date: date)
            case .Week:
                observedDate -= 86400 * 7
            }
        }
        .padding(2)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        
        Text(getCorrespondingDayTitle(date: date))
            .bold()
            .padding(2)
        
        Button(buttonNames[1]) {
            switch present {
            case .Day:
                observedDate += 86400
            case .Month:
                //moes the day to the first day of the next month
                observedDate += 86400 *
                    (getDayNum(date: lastDayOfMonth(date: date)) - getDayNum(date: date) + 1)
            case .Week:
                observedDate += 86400 * 7
            }
        }
        .padding(2)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder func createCalenderDisplay(date: Date) -> some View {
        if (present != .Month) {
            let dayAmount = (present == .Day) ? 1 : 7
            
            VStack {
                ForEach(0..<25) { hour in
                    Text(((hour < 10) ? "0" : "") + "\(hour)\n00")
                        .padding(.bottom, 5.0)
                }
            }
            .frame(maxWidth: 40,
                   maxHeight: .infinity,
                   alignment: .top)
            .background(Color.pink)
            
            ForEach(0..<dayAmount, id: \.self) {_ in
                Rectangle()
                    .frame(maxWidth: 2,
                           maxHeight: .infinity)
                
                DayView(width: .infinity/*, startOfWeek(date: observedDate)*/)
            }
        }
        else {
            let firstDayOfMonth = date - 86400 * (getDayNum(date: date) - 1)
            let trackerDay = firstDayOfMonth - 86400 * (getWeekDayNum(date: firstDayOfMonth) - 1)
            let numOfWeeks = Int(getWeekNum(date: lastDayOfMonth(date: date)))
            
            VStack {
                ForEach(0..<numOfWeeks, id: \.self) {week in
                    HStack {
                        ForEach(0..<7) {weekday in
                            let daysSince = Double(((7 * week) + weekday))
                            let dayNum = Int(getDayNum(date: trackerDay + 86400 * daysSince))
                            let monthNum = Int(getMonthNum(date: trackerDay + 86400 * daysSince))
                            let outLineColor = (monthNum == Int(getMonthNum(date: date))) ? Color.black : Color.gray
                            let backgroundColor = (compareDays(date1: Date(), date2: trackerDay + 86400 * daysSince)) ? Color.teal : Color.white
                            
                            Text("\(dayNum)")
                                .onTapGesture(count: 2, perform: {
                                    present = .Day
                                    observedDate = trackerDay + 86400 * daysSince
                                    turnOnDisplayButton(buttonIndex: 0)
                                    turnOffDisplayButton(buttonIndex: 1)
                                    turnOffDisplayButton(buttonIndex: 2)
                                })
                                .padding(.vertical, 30.0)
                                .frame(maxWidth: .infinity,
                                       idealHeight: 100)
                                .border(outLineColor,
                                        width: (monthNum == Int(getMonthNum(date: date))) ? 2 : 1)
                                .foregroundStyle(outLineColor)
                                .background(backgroundColor)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder func displayWeekdayText(date: Date) -> some View {
        if (present != .Day) {
            let paddingArrWeek: [Double] =
                [27.5, 13, 10, 10, 10, 18, 10]
            let paddingArrMonth: [Double] =
                [0, 18, 16.5, 15, 20, 21, 20]
            let weekdayArr: [String] =
                ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"]
            
            if (present == .Week) {
                Text("")
                    .padding(.trailing,
                             ((present == .Week) ? paddingArrWeek : paddingArrMonth)[0])
            }
            
            ForEach(0..<7, id:\.self) { index in
                let refDay = startOfWeek(date: date) + Double(86400 * index)
                
                VStack {
                    Text(weekdayArr[index])
                    Text((present == .Week) ?
                         "\(Int(getDayNum(date: refDay)))" : "")
                        .bold()
                }
                .padding(.trailing,
                         ((present == .Week) ? paddingArrWeek : paddingArrMonth)[1])
                .background((present == .Week && compareDays(date1: Date(), date2: refDay)) ? Color.teal : Color.white)
            }
        }
        else {
            Text(date.formatted(
                Date.FormatStyle().weekday(.wide)
            ))
            .background((compareDays(date1: Date(), date2: date)) ? Color.teal : Color.white)
        }
    }
    
}

#Preview {
    ScheduleView(ID: "demoo", 
                 mainScreen: ContentView(showSchedule: true))
}
