//
//  Helper.swift
//  real_voice_alarm
//
//  Created by yonmo on 2021/10/28.
//

import Foundation

func getCreationDate(for file: URL)->Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
       let creationDate = attributes[FileAttributeKey.creationDate] as? Date{
        return creationDate
    }else{
        return Date()
    }
}

func createDate(weekday: Int, hour: Int, minute: Int, year: Int)->Date{
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    components.year = year
    components.weekday = weekday // sunday = 1 ... saturday = 7
    components.weekdayOrdinal = 10
    components.timeZone = .current
    
    let calendar = Calendar(identifier: .gregorian)
    return calendar.date(from: components)!
}
