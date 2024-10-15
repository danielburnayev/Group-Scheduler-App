//
//  DayView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/3/24.
//

import Foundation
import SwiftUI

struct DayView: View {
    
    @State var width: CGFloat
    //@State var associatedDate: Date
    
    var body : some View {
        VStack {
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 1")
            EventView(eventColor: .blue, startTime: "0010", endTime: "0210", eventDescription: "Event 2")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 3")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 4")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 5")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 6")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 7")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 8")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 9")
            EventView(eventColor: .orange, startTime: "0010", endTime: "0210", eventDescription: "Event 10")
            EventView(eventColor: .purple, startTime: "0010", endTime: "0210", eventDescription: "Event 11")
            EventView(eventColor: .gray, startTime: "0010", endTime: "0210", eventDescription: "Event 12")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 13")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 14")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 15")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 16")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 17")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 18")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 19")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 20")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 21")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 22")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 23")
            EventView(eventColor: .yellow, startTime: "0010", endTime: "0210", eventDescription: "Event 24")
        }
        .frame(minWidth: 1,
               maxWidth: width,
               minHeight: 1,
               maxHeight: .infinity,
               alignment: .top)
    }
    
}

#Preview {
    DayView(width: 300/*, associatedDate: Date()*/)
}
