//
//  statusItem.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/25.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation
//import Firebase

struct WorkoutData {
    
    var convertedDate: String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = timestampToDate else { return "" }
        
        let convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    var timestampToDate: Date?
    
    let workoutTime: Int
    
    let title: String
    
    let activityType: String
    
}

struct ActivityEntry {
    let title: String
    let time: Int
    let activityType: String
}
