//
//  AddEventScreenView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/20/24.
//

import Foundation
import SwiftUI

struct AddEventScreenView: View {
    @State private var startAMPMChecker: Bool = true
    @State private var endAMPMChecker: Bool = true
    @State private var twelveHourTime: Bool = true
    @State private var newEventStartTime: String = ""
    @State private var newEventEndTime: String = ""
    @State private var timeTypeTitle: String = "12 HR"
    @State private var errorMessage: String = ""
    @State private var selectedDate: Date = Date()
    @State private var prevCharValue: UInt8? = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Add Event:")
                .bold()
                .padding([.top], 5)
            
            HStack {
                HStack(spacing: 1) {
                    TextField("Start Time:", text: $newEventStartTime)
                        .frame(maxWidth: 100, maxHeight: 30)
                        .padding(2)
                        .background(Color(red: 84/255, green: 215/255, blue: 255/255, opacity: 1.0))
                        .clipShape(Capsule())
                        .multilineTextAlignment(.center)
                        .onChange(of: newEventStartTime) {
                            if (twelveHourTime) {
                                newEventStartTime = enforce12HrFormat(eventTime: newEventStartTime)
                            }
                            else {
                                newEventStartTime = enforce24HrFormat(eventTime: newEventStartTime)
                            }
                            
                        }
                    
                    if (twelveHourTime) {
                        Toggle((startAMPMChecker) ? "AM" : "PM",
                               isOn: $startAMPMChecker)
                            .toggleStyle(.button)
                            .border(Color.blue, width: 1.5)
                    }
                }
                
                Text("–")
                
                HStack(spacing: 1) {
                    TextField("End Time:", text: $newEventEndTime)
                        .frame(maxWidth: 100, maxHeight: 30)
                        .padding(2)
                        .background(Color(red: 84/255, green: 215/255, blue: 255/255, opacity: 1.0))
                        .clipShape(Capsule())
                        .multilineTextAlignment(.center)
                        .onChange(of: newEventEndTime) {
                            if (twelveHourTime) {
                                newEventEndTime = enforce12HrFormat(eventTime: newEventEndTime)
                            }
                            else {
                                newEventEndTime = enforce24HrFormat(eventTime: newEventEndTime)
                            }
                        }
                    
                    if (twelveHourTime) {
                        Toggle((endAMPMChecker) ? "AM" : "PM",
                               isOn: $endAMPMChecker)
                            .toggleStyle(.button)
                            .border(Color.blue, width: 1.5)
                    }
                }
                
                Toggle(timeTypeTitle, isOn:$twelveHourTime)
                    .toggleStyle(.button)
                    .onChange(of: twelveHourTime) {
                        errorMessage = ""
                        newEventStartTime = ""
                        newEventEndTime = ""
                        
                        
                        timeTypeTitle =
                        ((twelveHourTime) ? "12" : "24") + " HR"
                    }
                    .cornerRadius(5)
                    .border(Color.blue, width: 2)
            }
            
            DatePicker("Day:",
                       selection: $selectedDate,
                       displayedComponents: [.date])
                .frame(maxWidth: 170)
                .onChange(of: selectedDate) {
                    let hourToSec = Calendar.current.component(Calendar.Component.hour, from: selectedDate) * 3600
                    let minToSec = Calendar.current.component(Calendar.Component.minute, from: selectedDate) * 60
                    
                    selectedDate -= Double(hourToSec + minToSec)
                    //selectedDate += Double()
                }
        
            Button("Include New Event") {
                
                dismiss()
            }
            .padding()
            .foregroundStyle(Color.black)
            .background(Color.blue)
            .clipShape(Capsule())
            
            Text(errorMessage)
                .foregroundStyle(Color.red)
        }
        .presentationDetents([.height(250), .large])
        .frame(alignment: .leading)
    }
    
    func enforce12HrFormat(eventTime: String) -> String {
        var newEventTime = eventTime
        let charValue: UInt8
        let theIndex: String.Index
        if let thing = newEventTime.firstIndex(where: {$0.asciiValue! < 48 || $0.asciiValue! > 58}) {
            charValue = newEventTime[thing].asciiValue!
            theIndex = thing
        }
        else {
            charValue = newEventTime.last?.asciiValue ?? 0
            theIndex = newEventTime.endIndex
        }
        
        if (newEventTime.count > 5) {
            
        }
        else if (charValue != 0 && (charValue < 48 || charValue > 57)) {
            
        }
        else if ((prevCharValue == 0 ||
                  (prevCharValue! >= 48 && prevCharValue! <= 58)) &&
                    (charValue == 0 || (charValue >= 48 && charValue <= 58))) {
            errorMessage = ""
        }
        
        prevCharValue = charValue
        
        return newEventTime
    }
    
    func enforce24HrFormat(eventTime: String) -> String {
        var newEventTime = eventTime
        let charValue: UInt8
        let theIndex: String.Index
        if let thing = newEventTime.firstIndex(where: {$0.asciiValue! < 48 || $0.asciiValue! > 57}) {
            charValue = newEventTime[thing].asciiValue!
            theIndex = thing
        }
        else {
            charValue = newEventTime.last?.asciiValue ?? 0
            theIndex = newEventTime.endIndex
        }
        
        if (newEventTime.count > 4) {
            if (charValue >= 48 && charValue <= 57) {newEventTime = String(newEventTime.dropLast())}
            else {newEventTime.remove(at: theIndex)}
        }
        else if (charValue != 0 && (charValue < 48 || charValue > 57)) {
            newEventTime.remove(at: theIndex)
            errorMessage = "Only numbers 0 through 9 are allowed."
        }
        else if ((prevCharValue == 0 ||
                  (prevCharValue! >= 48 && prevCharValue! <= 57)) &&
                    (charValue == 0 || (charValue >= 48 && charValue <= 57))) {
            errorMessage = ""
        }
        
        prevCharValue = charValue
        
        return newEventTime
    }
    
    func checkTime() {
        
    }
}

#Preview {
    AddEventScreenView()
}

