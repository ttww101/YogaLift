//
//  Date+Extension.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/22.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

extension Date {
    
    // swiftlint:disable identifier_name
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded()) // Date to millisecond
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000)) // millisecond to Date
    }
    
    var startOfWeek: Date? {
        var cal = Calendar.current
        cal.firstWeekday = 2
        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        comps.weekday = 2
        let mondayInWeek = cal.date(from: comps)!
        return mondayInWeek
        
//        var gregorian = Calendar(identifier: .gregorian)
//        guard let sunday = gregorian.date(
//            from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
//            ) else { return nil }
//        return gregorian.date(byAdding: .day, value: 1, to: sunday)
////        return gregorian.date(byAdding: .day, value: -6, to: sunday)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month],
                from: Calendar.current.startOfDay(for: self))
            )!
    }

    func dateAt(hours: Int, minutes: Int) -> Date {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
    func dayOf(_ day: Day) -> Date {
        guard let monday = self.startOfWeek else { return Date() }
        switch day {
        case .monday: return self.startOfWeek!
        case .tuesday: return Calendar.current.date(byAdding: .day, value: 1, to: monday)!
        case .wednesday: return Calendar.current.date(byAdding: .day, value: 2, to: monday)!
        case .thursday: return Calendar.current.date(byAdding: .day, value: 3, to: monday)!
        case .friday: return Calendar.current.date(byAdding: .day, value: 4, to: monday)!
        case .saturday: return Calendar.current.date(byAdding: .day, value: 5, to: monday)!
        case .sunday: return Calendar.current.date(byAdding: .day, value: 6, to: monday)!
        }
    }
    
    enum Day {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    func getConvert() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        let dateFormatString: String = dateFormatter.string(from: self)
        return dateFormatString
    }
    
    func getConvertHaveTime() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        let dateFormatString: String = dateFormatter.string(from: self)
        return dateFormatString
    }
    
    func getLCTime() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        let dateFormatString: String = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "HH:mm:ss.000"
        let timeFormatString: String = dateFormatter.string(from: self)
        
        return "\(dateFormatString)T\(timeFormatString)Z"
    }
}
