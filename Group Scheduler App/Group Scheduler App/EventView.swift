//
//  EventView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/3/24.
//

import Foundation
import SwiftUI

struct EventView: View {
    
    @State var eventColor: Color
    @State var startTime: String
    @State var endTime: String
    @State var eventDate: Date
    @State var eventDescription: String
    @Binding var twelveHourTime: Bool
    
    var body : some View {
        VStack {
            Text("\(startTime)\n\(endTime)")
                .padding(EdgeInsets(top: 7.5, leading: 0, bottom: 5, trailing: 0))
            Text("\(eventDescription)")
                .bold()
                .font(.system(size: 20))
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 7.5, trailing: 0))
        }
        .frame(minWidth: 1,
               maxWidth: 393,
               minHeight: 1,
               maxHeight: 150,
               alignment: .topLeading)
        .background(eventColor)
        .cornerRadius(5)
        .onAppear() {
            if (twelveHourTime && !startTime.contains(":")) {twentyFourHourTo12Hour()}
            else if (!twelveHourTime && startTime.contains(":")) {twelveHourTo24Hour()}
        }
        .onChange(of: twelveHourTime) {
            if (!twelveHourTime) {twelveHourTo24Hour()}
            else {twentyFourHourTo12Hour()}
        }
    }
    
    func twelveHourTo24Hour() {
        let startTimeArr = startTime.split(separator: ":")
        let endTimeArr = endTime.split(separator: ":")
        
        startTime = ""
        endTime = ""
        
        let startFirst = Int(startTimeArr[0])!
        let startSecond = Int(startTimeArr[1].prefix(2))!
        let startAmOrPm = startTimeArr[1].suffix(2)
        
        let first = ((startFirst == 12) ? startFirst - 12 : startFirst) * 100 + ((startAmOrPm == "am") ? 0 : 12) * 100 + startSecond
        if (first < 1000) {startTime += "0"}
        startTime += String(first)
        
        let endFirst = Int(endTimeArr[0])!
        let endSecond = Int(endTimeArr[1].prefix(2))!
        let endAmOrPm = endTimeArr[1].suffix(2)
        
        let end = ((endFirst == 12) ? endFirst - 12 : endFirst) * 100 + ((endAmOrPm == "am") ? 0 : 12) * 100 + endSecond
        if (end < 1000) {endTime += "0"}
        endTime += String(end)
    }
    
    func twentyFourHourTo12Hour() {
        var startAmPm = true
        var startFirst = Int(startTime.prefix(2))!
        let startSecond = Int(startTime.suffix(2))!
        
        print(startFirst)
        print(startSecond)
        print()
        
        if (startFirst > 12) {
            startFirst -= 12
            startAmPm = false
        }
        startTime = String(startFirst) + ":" + ((startSecond < 10) ? "0" : "") + String(startSecond) + ((startAmPm) ? "am" : "pm")
        
        var endAmPm = true
        var endFirst = Int(endTime.prefix(2))!
        let endSecond = Int(endTime.suffix(2))!
        
        if (endFirst > 12) {
            endFirst -= 12
            endAmPm = false
        }
        endTime = String(endFirst) + ":" + ((endSecond < 10) ? "0" : "") + String(endSecond) + ((endAmPm) ? "am" : "pm")
    }
}

//#Preview {
//    EventView(eventColor: .yellow, 
//              startTime: "3:00pm", endTime: "6:00pm",
//              eventDate: Date(),
//              eventDescription: "Event 1")
//}
