//
//  DateConverterForList.swift
//  ToDo App
//  Class is for date conversion and getting today's date
//  Created by Jemimah Beryl M. Sai on 05/05/2018.
//  Copyright © 2018 Jemimah Beryl M. Sai. All rights reserved.
//

import Foundation

class MyDate {
    let calender = Calendar.autoupdatingCurrent
    let format = DateFormatter()
    var today: Date { return Date() }
    
    func dateToString (_ date: Date) -> String {
        format.dateFormat = "MMM d, yyyy hh:mm a"
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier )
        return format.string(from: date)
    }
    
    func stringToDate (_ dateStr: String) -> Date {
        format.dateFormat = "MMM d, yyyy hh:mm a"
        format.timeZone = TimeZone(identifier: TimeZone.current.identifier )
        let myDate = format.date(from: dateStr)
        return myDate!
    }
    
}

