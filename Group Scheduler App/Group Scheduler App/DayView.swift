//
//  DayView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/3/24.
//

import Foundation
import SwiftUI

struct DayView: View {
    
    @State var associatedDate: Date
    @Binding var events: [EventView]
    @Binding var twelveHour: Bool
    
    var body : some View {
        ZStack {
            ForEach(0..<events.count, id:\.self) { index in
                events[index]
                    .offset(y: CGFloat(integerLiteral: Date.getHourNum(date: events[index].eventStartDate)) * ((twelveHour) ? 115 : 125) +
                                   (CGFloat(integerLiteral: Date.getMinuteNum(date: events[index].eventStartDate)) / 60) * ((twelveHour) ? 115 : 125))
            }
            //115 padding for every hour (for AMPM)
            //125 padding for every hour (for 24-hour)
        }
        .frame(minWidth: 1,
               maxWidth: .infinity,
               minHeight: 1,
               maxHeight: .infinity,
               alignment: .top)
    }
    
}
