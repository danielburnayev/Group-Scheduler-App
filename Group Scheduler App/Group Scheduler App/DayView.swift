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
            }
        }
        .frame(minWidth: 1,
               maxWidth: .infinity,
               minHeight: 1,
               maxHeight: .infinity,
               alignment: .top)
    }
    
}
