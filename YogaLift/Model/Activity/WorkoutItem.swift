//
//  WorkoutItem.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 SSMNT. All rights reserved.
//

struct WorkoutElement: Codable {
    let description, icon, id, title: String
    let time: Int?
    let workoutSet: [WorkoutSet]
}

struct WorkoutSet: Codable {
    let title: String
    let thumbnail: String
    let count: Int
    let workoutSetRepeat: Int
    let hint: String
    let description: String
    let perDuration: Double
    let annotation: [String]?
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case count, description, title, images, thumbnail, hint
        case perDuration
        case workoutSetRepeat = "repeat"
        case annotation
    }
}

enum ActivityItems {
    case train
    case yinyoga
    func url() -> String {
        switch self {
        case .train: return "train"
        case .yinyoga: return "yinyoga"
        }
    }
}

enum TrainItems {
    case watchTV
    case backPain
    case wholeBody
    case upperBody
    case lowerBody
    func toIndex() -> Int {
        switch self {
        case .watchTV: return 0
        case .backPain: return 1
        case .wholeBody: return 2
        case .upperBody: return 3
        case .lowerBody: return 4
        }
    }
}
