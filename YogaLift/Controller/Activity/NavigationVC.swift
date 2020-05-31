//
//  NavigationVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/14.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {
    
    var workoutMinutes: Float?
    var workoutArray: [WorkoutSet]?
    var navTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootViewController = viewControllers.first as? CountDownVC {
            rootViewController.workoutMinutes = workoutMinutes
            rootViewController.workoutArray = workoutArray
            rootViewController.navTitle = navTitle
        }

    }

}
