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
                            newEventStartTime = (twelveHourTime) ? enforce12HrFormat(eventTime: newEventStartTime) : enforce24HrFormat(eventTime: newEventStartTime)
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
                            newEventEndTime = (twelveHourTime) ? enforce12HrFormat(eventTime: newEventEndTime) : enforce24HrFormat(eventTime: newEventEndTime)
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
                        clearErrorMessage()
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
                clearErrorMessage()
                if ((twelveHourTime) ? check12HourTime() : check24HourTime()) {
                    // more stuff
                    dismiss()
                }
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
    
    //make sure the first 1 or 2 characters are numbers
    //make sure the character after the first number/numbers is a colon
    //make sure the characters after the colon are 2 numbers
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
            clearErrorMessage()
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
            assignErrorMessage(message: "Only numbers 0 through 9 are allowed.")
        }
        else if ((prevCharValue == 0 ||
                  (prevCharValue! >= 48 && prevCharValue! <= 57)) &&
                    (charValue == 0 || (charValue >= 48 && charValue <= 57))) {
            clearErrorMessage()
        }
        
        prevCharValue = charValue
        
        return newEventTime
    }
    
    func check12HourTime() -> Bool {
        if (!checkTimeLength()) {return false}
        
        let startTimeArr = newEventStartTime.split(separator: ":")
        let endTimeArr = newEventEndTime.split(separator: ":")
        
        let startChecker = check12HourTimeDigits(arr: startTimeArr, errorMessage: "The start time must be a proper 12-hour time (remove any unnecessary zeros, if necessary).\n")
        let endChecker = check12HourTimeDigits(arr: startTimeArr, errorMessage: "The end time must be a proper 12-hour time (remove any unnecessary zeros, if necessary).\n")
        if (!startChecker || !endChecker) {return false}
        
        let startTime = twelveHourInto24Hour(timeArr: startTimeArr)
        let endTime = twelveHourInto24Hour(timeArr: endTimeArr)
        
        if (!checkForUnorderedTimes(startTime: startTime, endTime: endTime)) {return false}
        return true
    }
    
    func check12HourTimeDigits(arr: [Substring], errorMessage: String) -> Bool {
        var validTime = true
        
        if (arr[0].first! == "0" || Int(arr[0])! < 1 || Int(arr[0])! > 12 || Int(arr[1])! > 59) {
            appendToErrorMessage(message: errorMessage)
            validTime = false
        }
        
        return validTime
    }
    
    func twelveHourInto24Hour(timeArr: [Substring]) -> Int {
        return Int(timeArr[0])! * 100 + ((startAMPMChecker) ? 0 : 12) * 100 + Int(timeArr[1])!
    }
    
    func check24HourTime() -> Bool {
        if (!checkTimeLength()) {return false}
        
        let startTime = Int(newEventStartTime)!
        let endTime = Int(newEventEndTime)!
        
        let startCheck = check24HourTimeDigits(time: startTime, errorMessage: "The start time must be a proper 24-hour time.\n")
        let endCheck = check24HourTimeDigits(time: endTime, errorMessage: "The end time must be a proper 24-hour time.\n")
        if (!startCheck || !endCheck) {return false}
        
        if (!checkForUnorderedTimes(startTime: startTime, endTime: endTime)) {return false}
        return true
    }
    
    func check24HourTimeDigits(time: Int, errorMessage: String) -> Bool {
        var validTime = true
        
        if (time / 100 > 24 || time % 100 > 59 || time > 2400) {
            appendToErrorMessage(message: errorMessage)
            validTime = false
        }
        
        return validTime
    }
    
    func checkForUnorderedTimes(startTime: Int, endTime: Int) -> Bool {
        var timesInRightOrder = true
        
        if (startTime > endTime) {
            appendToErrorMessage(message: "The start time needs to be earlier than the end time.")
            timesInRightOrder = false
        }
        
        return timesInRightOrder
    }
    
    func checkTimeLength() -> Bool {
        var validLengths = true
        
        if (newEventStartTime.count < 4) {
            appendToErrorMessage(message: "The start time must be " + ((twelveHourTime) ? "at least " : "") +  "4 numbers long.\n")
            validLengths = false
        }
        if (newEventEndTime.count < 4) {
            appendToErrorMessage(message: "The end time must be " + ((twelveHourTime) ? "at least " : "") +  "4 numbers long.\n")
            validLengths = false
        }
        return validLengths
    }
    
    func addNewEvent() {}
    
    func clearErrorMessage() {errorMessage = ""}
    
    func assignErrorMessage(message: String) {errorMessage = message}
    
    func appendToErrorMessage(message: String) {errorMessage += message}
}

#Preview {
    AddEventScreenView()
}

