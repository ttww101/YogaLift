//
//  FinishWorkoutVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/12.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class FinishWorkoutVC: UIViewController {
    
    var currentTime: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            
            self.performSegue(withIdentifier: "unwindToSetupVC", sender: self)
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let desVC = segue.destination
        
        if let setupVC = desVC as? TrainSetupVC {
            
            setupVC.recordTrainTime = lroundf(currentTime / 60)
            
        } else if let setupVC = desVC as? YinYogaSetupVC {
            
            setupVC.recordYinYogaTime = lroundf(currentTime / 60)
            
        }
        
    }

}
