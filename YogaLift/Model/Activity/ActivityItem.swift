//
//  ActivityItem.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

struct ActivityGroup {

    let firstLineTitle: String

    let secondLineTitle: String

    let caption: String

    let items: [ActivityItem]
}

protocol ActivityItem {

    var title: String { get }

}

enum ActivityType: String {
    
    case train
    
    case yinyoga
}

enum TrainItem: ActivityItem {

    case TrainA

    case TrainB

    case TrainC

    case TrainD

    case TrainE

    var title: String {

        switch self {

        case .TrainA: return "起床静瑜珈"

        case .TrainB: return "工作静瑜珈"

        case .TrainC: return "基础静瑜珈"

        case .TrainD: return "进阶静瑜珈"

        case .TrainE: return "睡前静瑜珈"

        }

    }
}

enum YinYogaItem: ActivityItem {

    case YinYogaA

    case YinYogaB

    case YinYogaC
    
    case YinYogaD
    
    case YinYogaE

    var title: String {

        switch self {

        case .YinYogaA: return "起床阴瑜珈"

        case .YinYogaB: return "工作阴瑜珈"

        case .YinYogaC: return "基础阴瑜珈"
            
        case .YinYogaD: return "进阶阴瑜珈"
            
        case .YinYogaE: return "睡前阴瑜珈"

        }

    }

}
