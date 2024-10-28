//
//  ExtensionDateMethods.swift
//  Group Scheduler App
//
//  Created by Daniel Burnayev on 10/25/24.
//

import Foundation

extension Date {
    static func getYearNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().year()
        )) ?? 0
    }
    
    static func getMonthNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().month(.twoDigits)
        )) ?? 0
    }
    
    static func getWeekDayNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().weekday(.oneDigit)
        )) ?? 0
    }
    
    static func getWeekNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().week(.weekOfMonth)
        )) ?? 0
    }
    
    static func getDayNum(date: Date) -> Double {
        return Double(date.formatted(
            Date.FormatStyle().day()
        )) ?? 0
    }
    
    static func getHourNum(date: Date) -> Int {
        return Calendar.current.component(Calendar.Component.hour, from: date)
    }
    
    static func getMinuteNum(date: Date) -> Int {
        return Calendar.current.component(Calendar.Component.minute, from: date)
    }
    
    static func startOfWeek(date: Date) -> Date {
        return date - (86400 * (getWeekDayNum(date: date) - 1))
    }
    
    static func endOfWeek(date: Date) -> Date {
        return date + (86400 * (7 - getWeekDayNum(date: date)))
    }
    
    static func startOfDay(date: Date) -> Date {
        let hourToSec = Calendar.current.component(Calendar.Component.hour, from: date) * 3600
        let minToSec = Calendar.current.component(Calendar.Component.minute, from: date) * 60
        let sec = Calendar.current.component(Calendar.Component.second, from: date)
        
        return date - Double(hourToSec + minToSec + sec)
    }
    
    static func lastDayOfMonth(date: Date) -> Date {
        let dayNum = Int(getDayNum(date: date))
        var supposedLastDay = date + Double(86400 * (28 - dayNum))
        
        for maxDays in 29...31 {
            if (getMonthNum(date: supposedLastDay + 86400) != getMonthNum(date: date)) {break}
            supposedLastDay = date + Double(86400 * (maxDays - dayNum))
        }
        return supposedLastDay
    }
    
    static func compareDays(date1: Date, date2: Date) -> Bool {
            return getYearNum(date: date1) == getYearNum(date: date2) &&
            getMonthNum(date: date1) == getMonthNum(date: date2) &&
            getDayNum(date: date1) == getDayNum(date: date2)
        }
    
}
