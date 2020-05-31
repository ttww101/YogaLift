//
//  YinYogaNavVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/24.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class YinYogaNavVC: UINavigationController {

    var workoutMinutes: Float?
    var workoutArray: [WorkoutSet]?
    var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootViewController = viewControllers.first as? YinYogaCountdownVC {
            rootViewController.workoutMinutes = workoutMinutes
            rootViewController.workoutArray = workoutArray
            rootViewController.navTitle = navTitle
        }
        
    }
}
