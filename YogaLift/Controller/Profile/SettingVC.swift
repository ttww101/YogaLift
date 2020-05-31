//
//  SettingVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/22.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
////import Firebase

class SettingVC: UIViewController {
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        LeanCloudService.shared.clearObjectId()
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        dismiss(animated: true, completion: nil)
//        if Auth.auth().currentUser != nil {
//            do {
//                try Auth.auth().signOut()
//                dismiss(animated: true, completion: nil)
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
