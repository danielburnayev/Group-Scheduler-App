//
//  ContentView.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 9/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSchedule: Bool = false
    @State private var showJoinTextField: Bool = false
    @State private var errorMessage: String = ""
    @State private var scheduleID: String = ""
    @State private var storage: ScheduleStorage? = nil
    @State private var selectedScheduleIndex: Int = 0
    
    var body: some View {
        if (!showSchedule) {showIntroScreen()}
        else {storage?.indexAt(index: selectedScheduleIndex)}
    }
    
    func generateID() -> String {
        var theId = ""
        
        for _ in 0...4 {
            let randNum = Int.random(in: 0...22)
            var randChar : Character
            var unicodeAdder : Int
            
            if (randNum < 10) {unicodeAdder = 48}
            else if (randNum < 16) {unicodeAdder = 55}
            else {unicodeAdder = 81}
            
            randChar = Character(UnicodeScalar(randNum + unicodeAdder)!)
            
            theId += String(randChar)
        }
        
        return theId;
    }
    
    @ViewBuilder func showIntroScreen() -> some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = proxy.size.width
            
            VStack(spacing: height / 25.3) {
                displayHeaderText(width: width,
                                  height: height)
            
                displayCreateButton(width: width)
                
                addJoinSection(width: width)
                
                displayErrorSection()
            }
            .frame(maxWidth: .infinity, 
                   maxHeight: .infinity,
                   alignment: .top)
            .padding()
            .background(Color(red: 152/255, green: 255/255, blue: 177/255, opacity: 1.0))
            .onTapGesture {
                scheduleID = ""
                errorMessage = ""
                showJoinTextField = false
            }
        }
    }
    
    @ViewBuilder func displayHeaderText(width: Double, height: Double) -> some View {
        Text("Scheduler App")
            .font(.system(size: width / 6.55))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.bottom, height / 9)
    }
    
    @ViewBuilder func displayCreateButton(width: Double) -> some View {
        Button("Create Schedule") {
            showJoinTextField = false
            scheduleID = generateID()
            
            if (storage == nil) {storage = ScheduleStorage(mainScreen: self)}
            
            storage?.addSchedule(schedule: ScheduleView(ID: scheduleID, mainScreen: self))
            selectedScheduleIndex = (storage?.getStorageLength() ?? 0) - 1
            
            if (selectedScheduleIndex > -1) {showSchedule = true}
            else {errorMessage = "Schedule storage has not been initialized."}
        }
        .padding(30)
        .background(Color(red: 217/255, green: 217/255, blue: 52/255, opacity: 1.0))
        .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.85))
        .font(.system(size: width / 13.1)) //og font size 30
        .cornerRadius(12.5)
    }
    
    @ViewBuilder func addJoinSection(width: Double) -> some View {
        if (!showJoinTextField) {displayJoinButton(width: width)}
        else {displayJoinTextField(width: width)}
    }
    
    @ViewBuilder func displayJoinButton(width: Double) -> some View {
        Button("Join Schedule") {
            showJoinTextField = true
            if (storage == nil) {storage = ScheduleStorage(mainScreen: self)}
        }
        .padding(30)
        .background(Color(red: 84/255, green: 215/255, blue: 255/255, opacity: 1.0))
        .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.85))
        .font(.system(size: width / 13.1)) //og font size 30
        .cornerRadius(12.5)
    }
    
    @ViewBuilder func displayJoinTextField(width: Double) -> some View {
        TextField("Enter Schedule ID",
                  text: $scheduleID)
        .onChange(of: scheduleID) {
            if (scheduleID.count > 5) {scheduleID = String(scheduleID.dropLast())}
            else {errorMessage = ""}
        }
        .onSubmit {
            if (scheduleID.count == 5) {
                selectedScheduleIndex = storage?.getSpecificScheduleIndex(scheduleID: scheduleID) ?? -2
                if (selectedScheduleIndex > -1) {showSchedule = true}
                else if (selectedScheduleIndex == -1) {errorMessage = "Schedule with id: \"\(scheduleID)\" doesn't exist"}
                else {
                    errorMessage = "Schedule storage has not been initialized."
                }
            }
            else {errorMessage = "ID must be 5 characters long!"}
        }
        .onTapGesture {} //overrides background's onTap
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        .padding(30)
        .background(Color(red: 84/255, green: 215/255, blue: 255/255, opacity: 1.0))
        .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.85))
        .font(.system(size: width / 13.1)) //og font size 30
        .cornerRadius(12.5)
    }
    
    @ViewBuilder func displayErrorSection() -> some View {
        Text(errorMessage)
            .bold()
            .foregroundStyle(Color(.red))
    }
    
}

#Preview {
    ContentView(showSchedule: false)
}
