//
//  HomeObject.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation
//import Firebase

struct HomeObject: Codable {
    
    let status, title, background: String
    
    let workoutSet: [HomeWorkoutSet]
}

struct HomeWorkoutSet: Codable {
    
    let title, buttonImage, id: String
}

enum HomeStatus {
    
    case resting
    
    case working
    
    case beforeSleep
    
    func url() -> String {
        
        switch self {
            
        case .resting: return "0"
            
        case .working: return "1"
            
        case .beforeSleep: return "2"
        }
    }
}

struct WorkOut {
    
    var workOutTime: Int
    
    var activityType: String
    
    var createdTime: Date
    
//    enum CodingKeys: String, CodingKey {
//        
//        case workOutTime = "workout_time"
//        
//        case activityType = "activity_type"
//    }
}
