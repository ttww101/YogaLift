//
//  UserItem.swift
//   WorkOutLift
//
//  Created by Apple on 2019/7/5.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String? { get set }
}

struct UserItem: Codable {
    
    var name: String
    var signupTime: Date
    var expectedWeight: Double
    var initialWeight: Double
    
    enum CodingKeys: String, CodingKey {
        case expectedWeight = "expected_weight"
        case initialWeight = "initial_weight"
        case signupTime = "signup_time"
        case name
    }
    
}
