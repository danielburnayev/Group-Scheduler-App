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
    
    var body : some View {
        VStack {
            ForEach(0..<events.count, id:\.self) { index in
                events[index]
                    .padding(.top, CGFloat(integerLiteral: Date.getHourHum(date: events[index].eventDate)) * 115 +
                                   (CGFloat(integerLiteral: Date.getMinuteHum(date: events[index].eventDate)) / 60) * 115)
            }
            //115 padding for every hour (for now)
        }
        .frame(minWidth: 1,
               maxWidth: .infinity,
               minHeight: 1,
               maxHeight: .infinity,
               alignment: .top)
    }
    
}
