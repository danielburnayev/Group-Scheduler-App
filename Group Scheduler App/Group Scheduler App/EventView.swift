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
    @State var eventDescription: String
    
    var body : some View {
        VStack {
            Text("\(startTime)\n\(endTime)")
//            Text("\(eventDescription)")
//                .bold()
//                .font(.system(size: 20))
        }
        .frame(minWidth: 1,
               maxWidth: 393,
               minHeight: 1,
               maxHeight: 150,
               alignment: .topLeading)
            //.padding()
            .background(eventColor)
            .cornerRadius(5)
    }
}

#Preview {
    EventView(eventColor: .yellow, startTime: "3:00pm", endTime: "6:00pm", eventDescription: "Sample Description")
}
