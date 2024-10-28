//
//  AddEventScreenView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/20/24.
//

import Foundation
import SwiftUI

struct AddEventScreenView: View {
    @State var requestingSchedule: ScheduleView
    @State var twelveHour: Bool
    @State private var startAMPMChecker: Bool = true
    @State private var endAMPMChecker: Bool = true
    @State private var newEventStartTime: String = ""
    @State private var newEventEndTime: String = ""
    @State private var newEventDescription: String = ""
    @State private var timeTypeTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var selectedDate: Date = Date.startOfDay(date: Date())
    @State private var prevCharValue: UInt8? = 0
    @State private var prevI: Int? = nil
    @Environment(\.dismiss) private var dismiss
    
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
                        .onChange(of: newEventStartTime) { before, after in
                            newEventStartTime = (twelveHour) ? enforce12HrFormat(eventTime: newEventStartTime, before) : enforce24HrFormat(eventTime: newEventStartTime)
                        }
                    
                    if (twelveHour) {
                        Toggle((startAMPMChecker) ? "AM" : "PM",
                               isOn: $startAMPMChecker)
                        .toggleStyle(.button)
                        .border(Color.blue, width: 1.5)
                        .onChange(of: startAMPMChecker) {clearErrorMessage()}
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
                        .onChange(of: newEventEndTime) { before, after in
                            newEventEndTime = (twelveHour) ? enforce12HrFormat(eventTime: newEventEndTime, before) : enforce24HrFormat(eventTime: newEventEndTime)
                        }
                    
                    if (twelveHour) {
                        Toggle((endAMPMChecker) ? "AM" : "PM",
                               isOn: $endAMPMChecker)
                        .toggleStyle(.button)
                        .border(Color.blue, width: 1.5)
                        .onChange(of: endAMPMChecker) {clearErrorMessage()}
                    }
                }
                
                Toggle(timeTypeTitle, isOn:$twelveHour)
                    .toggleStyle(.button)
                    .onChange(of: twelveHour) {
                        clearErrorMessage()
                        newEventStartTime = ""
                        newEventEndTime = ""
                        
                        timeTypeTitle =
                        ((twelveHour) ? "12" : "24") + " HR"
                    }
                    .cornerRadius(5)
                    .border(Color.blue, width: 2)
            }
            
            DatePicker("Day:",
                       selection: $selectedDate,
                       displayedComponents: [.date])
            .frame(maxWidth: 170)
            .onChange(of: selectedDate) {
                clearErrorMessage()
                selectedDate = Date.startOfDay(date: selectedDate)
            }
            
            HStack {
                Text("Description:")
                
                TextField("Event Description", 
                          text: $newEventDescription,
                          axis: .vertical)
                     .padding([.leading], 5)
                    .frame(maxHeight: 50)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    .lineLimit(2, reservesSpace: true)
            }
            
            Button("Include New Event") {
                clearErrorMessage()
                if ((twelveHour) ? check12HourTime() : check24HourTime()) {
                    var finalStartTime = newEventStartTime
                    var finalEndTime = newEventEndTime
                    let timeStart: Int
                    let timeEnd: Int
                    if (twelveHour) {
                        finalStartTime += (startAMPMChecker) ? "am" : "pm"
                        finalEndTime += (endAMPMChecker) ? "am" : "pm"
                        timeStart = twelveHourInto24Hour(timeArr: newEventStartTime.split(separator: ":"),
                                                    amPM: startAMPMChecker)
                        timeEnd = twelveHourInto24Hour(timeArr: newEventEndTime.split(separator: ":"),
                                                       amPM: endAMPMChecker)
                    }
                    else {
                        timeStart = Int(finalStartTime)!
                        timeEnd = Int(finalEndTime)!
                    }
                    selectedDate += (Double(timeStart / 100) * 3600) + (Double(timeStart % 100) * 60)
                    let theEndDate = Date.startOfDay(date: Date()) + (Double(timeEnd / 100) * 3600) + (Double(timeEnd % 100) * 60)
                    
                    requestingSchedule.createEvent(eventColor: Color.yellow,
                                                   startTime: finalStartTime, endTime: finalEndTime,
                                                   eventStartDate: selectedDate,
                                                   eventEndDate: theEndDate,
                                                   eventDescription: newEventDescription)

                    dismiss()
                }
            }
            .padding()
            .foregroundStyle(Color.black)
            .background(Color.blue)
            .clipShape(Capsule())
            
            Text(errorMessage)
                .foregroundStyle(Color.red)
                .multilineTextAlignment(.center)
        }
        .presentationDetents([.height(325), .large])
        .frame(alignment: .leading)
        .onAppear() {
            timeTypeTitle = ((twelveHour) ? "12 " : "24 ") + "HR"
        }
    }
    
    private func enforce12HrFormat(eventTime: String, _ before: String) -> String {
        var beforeTemp = String(before)
        var newTimeTemp = String(eventTime)
        
        beforeTemp += (beforeTemp.count < 6) ? "\0" : ""
        
        var colonIndex = -1
        var newCharIndex: String.Index? = nil
        let beforeArr = Array(beforeTemp)
        let nowArr = Array(newTimeTemp)
        
//        print("Before: \(beforeArr)")
//        print("After: \(nowArr)")
        
        for i in 0..<newTimeTemp.count {
            // evaluates the newly added character
            if (newCharIndex == nil && beforeArr[i] != nowArr[i]) {
                var currErrorStr = ""
                //var beforeErrorStr = ""
                //var tempBeforeArr =
                newCharIndex = newTimeTemp.index(newTimeTemp.startIndex, offsetBy: i)
                
                checkForErrors12Hr(timeCount: newTimeTemp.count,
                               arr: nowArr,
                               i: i,
                               errorStr: &currErrorStr,
                               colonIndex: &colonIndex)
//                if (prevI != nil) {
//                    checkForErrors12Hr(timeCount: beforeArr.count,
//                                   arr: beforeArr,
//                                   i: prevI!,
//                                   errorStr: &beforeErrorStr,
//                                   colonIndex: &colonIndex)
//                }
                //print("\(i) \(prevI ?? -1)")
                
                //prevI = i
                
//                print("Before: \(beforeErrorStr) After: \(currErrorStr)")
                
                if (currErrorStr != "") {
                    newTimeTemp.remove(at: newCharIndex!)
                    assignErrorMessage(message: currErrorStr)
                    break
                }
            }
            //goes through all the other supposed-to-be-good characters
            else if (nowArr[i] == ":") {colonIndex = i}
        }
        
        return newTimeTemp
    }
    
    private func checkForErrors12Hr(timeCount: Int, arr: [Character], i: Int, errorStr: inout String, colonIndex: inout Int) {
        if (timeCount == 6) {
            errorStr = "Times cannot have a length of more than 5."
        }
        else if ( (arr[i].asciiValue! < 48 || arr[i].asciiValue! > 58)) {
            errorStr = "Only numbers 0 through 9 and the colon (:) are allowed."
        }
        else if (arr[i] == ":") {
            if (colonIndex != -1) {
                errorStr = "Times has more than one colon character (:)."
            }
            else if (i < 1 || i > 2) {
                errorStr = "The colon character is placed incorrectly."
            }
        }
        else if (arr[i].asciiValue ?? 0 >= 48 && arr[i].asciiValue ?? 0 <= 57) {
            if (timeCount > 1 && arr[1] == ":") {colonIndex = 1}
            else if (timeCount > 2 && arr[2] == ":") {colonIndex = 2}
            
            if ((colonIndex != -1 && timeCount - 1 - colonIndex > 2) ||
                (colonIndex == -1 && timeCount > 2)) {
                errorStr = "Numbers in the time are formatted incorrectly."
            }
        }
    }
    
    private func enforce24HrFormat(eventTime: String) -> String {
        var newEventTime = eventTime
        var charValue: UInt8
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
            assignErrorMessage(message: "Time cannot have a length of more than 4.")
            if (charValue >= 48 && charValue <= 57) {newEventTime = String(newEventTime.dropLast())}
            else {newEventTime.remove(at: theIndex)}
            charValue = 3 //forcing the ascii value to forcefully reach the proper else if branchs
        }
        else if (charValue != 0 && (charValue < 48 || charValue > 57)) {
            newEventTime.remove(at: theIndex)
            assignErrorMessage(message: "Only numbers 0 through 9 are allowed.")
        }
        else if ((prevCharValue == 0 || (prevCharValue! >= 48 && prevCharValue! <= 57)) &&
                 (charValue == 0 || (charValue >= 48 && charValue <= 57))) {
            clearErrorMessage()
        }
        
        prevCharValue = charValue
        
        return newEventTime
    }
    
    private func check12HourTime() -> Bool {
        if (!checkTimeLength()) {return false}
        
        let startTimeArr = newEventStartTime.split(separator: ":")
        let endTimeArr = newEventEndTime.split(separator: ":")
        
        let startChecker = check12HourTimeDigits(arr: startTimeArr, errorMessage: "The start time must be a proper 12-hour time.\n")
        let endChecker = check12HourTimeDigits(arr: endTimeArr, errorMessage: "The end time must be a proper 12-hour time.\n")
        if (!startChecker || !endChecker) {return false}
        
        let startTime = twelveHourInto24Hour(timeArr: startTimeArr, amPM: startAMPMChecker)
        let endTime = twelveHourInto24Hour(timeArr: endTimeArr, amPM: endAMPMChecker)
        
        return checkForUnorderedTimes(startTime: startTime, endTime: endTime)
    }
    
    private func check12HourTimeDigits(arr: [Substring], errorMessage: String) -> Bool {
        var validTime = true
        
        if (arr[0].first! == "0" || Int(arr[0])! < 1 || Int(arr[0])! > 12 || Int(arr[1])! > 59) {
            appendToErrorMessage(message: errorMessage)
            validTime = false
        }
        
        return validTime
    }
    
    private func twelveHourInto24Hour(timeArr: [Substring], amPM: Bool) -> Int {
        let firstInt = Int(timeArr[0])!
        let secondInt = Int(timeArr[1])!
        
        return ((firstInt == 12) ? firstInt - 12 : firstInt) * 100 + ((amPM) ? 0 : 12) * 100 + secondInt
    }
    
    private func check24HourTime() -> Bool {
        if (!checkTimeLength()) {return false}
        
        let startTime = Int(newEventStartTime)!
        let endTime = Int(newEventEndTime)!
        
        let startCheck = check24HourTimeDigits(time: startTime, errorMessage: "The start time must be a proper 24-hour time.\n")
        let endCheck = check24HourTimeDigits(time: endTime, errorMessage: "The end time must be a proper 24-hour time.\n")
        if (!startCheck || !endCheck) {return false}
        
        return checkForUnorderedTimes(startTime: startTime, endTime: endTime)
    }
    
    private func check24HourTimeDigits(time: Int, errorMessage: String) -> Bool {
        var validTime = true
        
        if (time / 100 > 24 || time % 100 > 59 || time > 2400) {
            appendToErrorMessage(message: errorMessage)
            validTime = false
        }
        
        return validTime
    }
    
    private func checkForUnorderedTimes(startTime: Int, endTime: Int) -> Bool {
        var timesInRightOrder = true
        
        if (startTime > endTime) {
            appendToErrorMessage(message: "The start time needs to be earlier than the end time.")
            timesInRightOrder = false
        }
        
        return timesInRightOrder
    }
    
    private func checkTimeLength() -> Bool {
        var validLengths = true
        
        if (newEventStartTime.count < 4) {
            appendToErrorMessage(message: "The start time must be " + ((twelveHour) ? "at least " : "") +  "4 characters long.\n")
            validLengths = false
        }
        if (newEventEndTime.count < 4) {
            appendToErrorMessage(message: "The end time must be " + ((twelveHour) ? "at least " : "") +  "4 characters long.\n")
            validLengths = false
        }
        return validLengths
    }
    
    private func clearErrorMessage() {errorMessage = ""}
    
    private func assignErrorMessage(message: String) {errorMessage = message}
    
    private func appendToErrorMessage(message: String) {errorMessage += message}
}

#Preview {
    AddEventScreenView(requestingSchedule: ScheduleView(ID: "demoo",
                                                        mainScreen: ContentView(showSchedule: false)), twelveHour: true)
}

