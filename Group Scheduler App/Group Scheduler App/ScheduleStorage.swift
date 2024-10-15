//
//  ScheduleStorage.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/6/24.
//

import Foundation

class ScheduleStorage {
    private var schedules: [ScheduleView] = []
    var mainScreen: ContentView
    
    init(mainScreen: ContentView) {
        self.mainScreen = mainScreen
        self.schedules.append(ScheduleView(ID: "demoo", mainScreen: self.mainScreen))
    }
    
    func addSchedule(schedule: ScheduleView) {
        schedules.append(schedule)
    }
    
    func getSpecificScheduleIndex(scheduleID: String) -> Int {
        for index in 0..<schedules.count {
            if (schedules[index].ID == scheduleID) {return index}
        }
        return -1
    }
    
    func getStorageLength() -> Int {
        return schedules.count
    }
    
    func indexAt(index: Int) -> ScheduleView {
        return schedules[index]
    }
}

