//
//  WeightItem.swift
//   WorkOutLift
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

struct WeightData {
    
    var createdTime: Date?
    
    let weight: Double
    
    var documentID: String?
    
    var createdTimeString: String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M月d日"
        
        guard let date = createdTime else { return "" }
        
        let createdTimeString = dateFormatter.string(from: date)
        
        return createdTimeString
    }

}
