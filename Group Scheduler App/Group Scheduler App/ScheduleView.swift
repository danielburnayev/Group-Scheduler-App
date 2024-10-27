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
    @State var twelveHourTime: Bool = true
    @State private var leaveSchedule: Bool = false
    @State private var showEventAdderScreen: Bool = false
    @State private var timeTypeTitle: String = "12 HR"
    @State private var present: SchedulePresentOption = .Week
    @State private var observedDate: Date = Date()
    @State private var displayButtonColors: [[Color]] =
    [[Color.white, Color.blue],
     [Color.blue, Color.white],
     [Color.white, Color.blue]]
    @State private var eventDictionary: [DateComponents : [EventView]] = [:]
    @State private var bottomSheet: Bool = true
    
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
                .foregroundStyle(displayButtonColors[0][1])
                
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
                .foregroundStyle(displayButtonColors[1][1])
                
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
                .foregroundStyle(displayButtonColors[2][1])
                
                if (present != .Month) {
                    Toggle(timeTypeTitle, isOn:$twelveHourTime)
                        .toggleStyle(.button)
                        .onChange(of: twelveHourTime) {
                            timeTypeTitle =
                            ((twelveHourTime) ? "12" : "24") + " HR"
                        }
                        .border(Color.blue, width: 2)
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
                    ZStack {
                        if (present != .Month) {
                            VStack {
                                displayTimeGuidelines()
                            }
                        }
                        
                        HStack {
                            createCalenderDisplay(date: observedDate)
                        }
                    }
                }
                .background(Color(red: 74/255, green: 255/255, blue: 230/255, opacity: 1.0))
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)
                
                HStack {
                    Button("Back to main") {
                        leaveSchedule = true
                        mainScreen.showSchedule = false
                        
                    }
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    
                    Button("Add Event") {
                        showEventAdderScreen = true
                    }
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    
                    Button("Demo button") {
                        addEvent(event: EventView(eventColor: Color.red,
                                                  startTime: "1:00am", endTime: "2:00am",
                                                  eventDate: Date.startOfWeek(date: observedDate),
                                                  eventDescription: "Demo 1",
                                                  twelveHourTime: $twelveHourTime))
                        
                        addEvent(event: EventView(eventColor: Color.blue,
                                                  startTime: "3:00am", endTime: "4:00am",
                                                  eventDate: Date.startOfWeek(date: observedDate) + 86400 * 1,
                                                  eventDescription: "Demo 2",
                                                  twelveHourTime: $twelveHourTime))
                        
                        addEvent(event: EventView(eventColor: Color.red,
                                                  startTime: "6:00am", endTime: "7:00am",
                                                  eventDate: Date.startOfWeek(date: observedDate) + 86400 * 2,
                                                  eventDescription: "Demo 3",
                                                  twelveHourTime: $twelveHourTime))
                        
                        addEvent(event: EventView(eventColor: Color.blue,
                                                  startTime: "8:00am", endTime: "9:00am",
                                                  eventDate: Date.startOfWeek(date: observedDate) + 86400 * 3,
                                                  eventDescription: "Demo 4",
                                                  twelveHourTime: $twelveHourTime))
                        
                        addEvent(event: EventView(eventColor: Color.orange,
                                                  startTime: "10:00am", endTime: "11:00am",
                                                  eventDate: Date.startOfWeek(date: observedDate) + 86400 * 4,
                                                  eventDescription: "Demo 5",
                                                  twelveHourTime: $twelveHourTime))
                    }
                    .border(Color.black, width: 1)
                }
                .frame(maxWidth: .infinity,
                       maxHeight: 30)
                .border(Color.black, width: 1)
                .sheet(isPresented: $showEventAdderScreen,
                       content: {
                        AddEventScreenView(requestingSchedule: self, twelveHour: twelveHourTime)
                       }
                )
            }
        }
        else {
            mainScreen
        }
    }
    
    func createEvent(eventColor: Color, startTime: String, endTime: String, eventDate: Date, eventDescription: String) {
        
        let e = EventView(eventColor: eventColor,
                          startTime: startTime, endTime: endTime,
                          eventDate: eventDate,
                          eventDescription: eventDescription,
                          twelveHourTime: $twelveHourTime)
        
        addEvent(event: e)
    }
    
    private func addEvent(event: EventView) {
        let date = Date.startOfDay(date: event.eventDate)
        let dateComps = DateComponents(year: Int(Date.getYearNum(date: date)),
                                       month: Int(Date.getMonthNum(date: date)), 
                                       day: Int(Date.getDayNum(date: date)))
        var dayEvents = eventDictionary[dateComps]
        
        if (dayEvents == nil) {dayEvents = [event]}
        else {dayEvents!.append(event)}
        
        eventDictionary.updateValue(dayEvents!, forKey: dateComps)
    }
    
    private func getCorrespondingButtonText() -> [String] {
        switch present {
        case .Day:
            return ["Yesterday", "Tommorow"]
        case .Month:
            return ["Last Month", "Next Month"]
        case .Week:
            return ["Last Week", "Next Week"]
        }
    }
    
    private func getCorrespondingDayTitle(date: Date) -> String {
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
                Date.startOfWeek(date: date)
                    .formatted(
                        Date.FormatStyle()
                            .month(.wide)
                            .day()
                    )
            
            let endDay =
                Date.endOfWeek(date: date)
                    .formatted(
                        Date.FormatStyle()
                            .month(.wide)
                            .day()
                    )
            
            return "\(startDay) – \(endDay)\n\(Int(Date.getYearNum(date: date)))"
        }
    }
      
    private func turnOnDisplayButton(buttonIndex: Int) {
        displayButtonColors[buttonIndex][0] = Color.blue
        displayButtonColors[buttonIndex][1] = Color.white
    }
    
    private func turnOffDisplayButton(buttonIndex: Int) {
        displayButtonColors[buttonIndex][0] = Color.white
        displayButtonColors[buttonIndex][1] = Color.blue
    }
    
    @ViewBuilder private func displayTimeRangeHeader(date: Date) -> some View {
        let buttonNames = getCorrespondingButtonText()
        Button(buttonNames[0]) {
            switch present {
            case .Day:
                observedDate -= 86400
            case .Month:
                //moes the day to the last day of the previous month
                observedDate -= 86400 * Date.getDayNum(date: date)
            case .Week:
                observedDate -= 86400 * 7
            }
        }
        .padding(2)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        
        Text(getCorrespondingDayTitle(date: date))
            .bold()
            .padding(2)
            .multilineTextAlignment(.center)
        
        Button(buttonNames[1]) {
            switch present {
            case .Day:
                observedDate += 86400
            case .Month:
                //moes the day to the first day of the next month
                observedDate += 86400 *
                (Date.getDayNum(date: Date.lastDayOfMonth(date: date)) - Date.getDayNum(date: date) + 1)
            case .Week:
                observedDate += 86400 * 7
            }
        }
        .padding(2)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder private func displayTimeGuidelines() -> some View {
                         //0,  1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,  1,   2,   3
        let padding12Arr = [105, 102, 103, 104, 102, 104, 106, 103, 104, 103, 104, 103, 104, 103, 103, 103, 103, 103, 103, 103, 104, 104, 104, 107]
        let padding24Arr = [115, 114, 114, 113, 113, 112, 112, 112, 111, 111, 111, 111, 111, 111, 111, 111, 112, 112, 112, 113, 113, 113, 113, 115]
        
        ForEach(0..<24) { hour in
            Rectangle()
                .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255, opacity: 0.7))
                .frame(width: .infinity, height: 1)
                .padding(EdgeInsets(top: 0,
                                    leading: 0,
                                    bottom: CGFloat((twelveHourTime) ? padding12Arr[hour] : padding24Arr[hour]),
                                    trailing: 0))
        }
    }
    
    @ViewBuilder private func createCalenderDisplay(date: Date) -> some View {
        if (present != .Month) {
            let dayAmount = (present == .Day) ? 1 : 7
            
            VStack {
                ForEach(0..<24) { hour in
                    let time24 = ((hour < 10) ? "0" : "") + "\(hour)00"
                    let time12 = make12HourTime(hour: hour)
                    Text((twelveHourTime) ? time12 : time24)
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 60, trailing: 3))
                        .font(.system(size: (twelveHourTime) ? 19 : 22))
                        .multilineTextAlignment(.center)
                }
                Text("")
            }
            .background(Color.pink)
            .frame(maxWidth: 40,
                   maxHeight: .infinity,
                   alignment: .top)
            
            ForEach(0..<dayAmount, id: \.self) {day in
                let givenDate = Date.startOfWeek(date: Date.startOfDay(date: date)) + Double(86400 * day)
                let dateComps = DateComponents(year: Int(Date.getYearNum(date: givenDate)),
                                               month: Int(Date.getMonthNum(date: givenDate)),
                                               day: Int(Date.getDayNum(date: givenDate)))
                let eventBinding = Binding(
                        get: { eventDictionary[dateComps] ?? [] },
                        set: { eventDictionary[dateComps] = $0 }
                    )
                
                Rectangle()
                    .frame(maxWidth: 2,
                           maxHeight: .infinity)
                
                DayView(associatedDate: givenDate, events: eventBinding, twelveHour: $twelveHourTime)
            }
        }
        else {
            let firstDayOfMonth = date - 86400 * (Date.getDayNum(date: date) - 1)
            let trackerDay = firstDayOfMonth - 86400 * (Date.getWeekDayNum(date: firstDayOfMonth) - 1)
            let numOfWeeks = Int(Date.getWeekNum(date: Date.lastDayOfMonth(date: date)))
            
            VStack {
                ForEach(0..<numOfWeeks, id: \.self) {week in
                    HStack {
                        ForEach(0..<7) {weekday in
                            let daysSince = Double(((7 * week) + weekday))
                            let dayNum = Int(Date.getDayNum(date: trackerDay + 86400 * daysSince))
                            let monthNum = Int(Date.getMonthNum(date: trackerDay + 86400 * daysSince))
                            let outLineColor = (monthNum == Int(Date.getMonthNum(date: date))) ? Color.black : Color.gray
                            let backgroundColor = (Date.compareDays(date1: Date(), date2: trackerDay + 86400 * daysSince)) ? Color.teal : Color.white
                            
                            Text("\(dayNum)")
                                .onTapGesture(perform: {
                                    observedDate = trackerDay + 86400 * daysSince
                                    present = .Day
                                    turnOnDisplayButton(buttonIndex: 0)
                                    turnOffDisplayButton(buttonIndex: 1)
                                    turnOffDisplayButton(buttonIndex: 2)
                                })
                                .padding(.vertical, 30.0)
                                .frame(maxWidth: .infinity,
                                       idealHeight: 100)
                                .border(outLineColor,
                                        width: (monthNum == Int(Date.getMonthNum(date: date))) ? 2 : 1)
                                .foregroundStyle(outLineColor)
                                .background(backgroundColor)
                        }
                    }
                }
            }
            .padding(.top, 5)
        }
    }
    
    private func make12HourTime(hour: Int) -> String {
        let hour12 = hour % 12
            
        if (hour12 == 0) {return "12 " + ((hour == 0) ? "am" : "pm")}
        return "\(hour12) " + ((hour < 12) ? "am" : "pm")
    }
    
    @ViewBuilder private func displayWeekdayText(date: Date) -> some View {
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
                let refDay = Date.startOfWeek(date: date) + Double(86400 * index)
                
                VStack {
                    Text(weekdayArr[index])
                    Text((present == .Week) ?
                         "\(Int(Date.getDayNum(date: refDay)))" : "")
                        .bold()
                }
                .onTapGesture(perform: {
                    observedDate = refDay
                    present = .Day
                    turnOnDisplayButton(buttonIndex: 0)
                    turnOffDisplayButton(buttonIndex: 1)
                    turnOffDisplayButton(buttonIndex: 2)
                })
                .padding(.trailing,
                         ((present == .Week) ? paddingArrWeek : paddingArrMonth)[1])
                .background((present == .Week && Date.compareDays(date1: Date(), date2: refDay)) ? Color.teal : Color.white)
            }
        }
        else {
            Text(date.formatted(
                Date.FormatStyle().weekday(.wide)
            ))
            .background((Date.compareDays(date1: Date(), date2: date)) ? Color.teal : Color.white)
        }
    }
    
}

#Preview {
    ScheduleView(ID: "demoo", 
                 mainScreen: ContentView(showSchedule: true),
                 twelveHourTime: true)
}
