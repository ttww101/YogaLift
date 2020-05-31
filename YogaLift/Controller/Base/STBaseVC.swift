//
//  STBaseVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/29.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class STBaseVC: LWBaseVC {
    
    var isHideNavigationBar: Bool {
        
        return false
    }
    
    var isEnableResignOnTouchOutside: Bool {
        
        return true
    }
    
    var isEnableIQKeyboard: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.9)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Icons_24px_Back02")
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Icons_24px_Back02")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
//        if !isEnableIQKeyboard {
//            IQKeyboardManager.shared().isEnabled = false
//        }
//
//        if !isEnableResignOnTouchOutside {
//            IQKeyboardManager.shared().shouldResignOnTouchOutside = false
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
//        if !isEnableIQKeyboard {
//            IQKeyboardManager.shared().isEnabled = true
//        }
//
//        if !isEnableResignOnTouchOutside {
//            IQKeyboardManager.shared().shouldResignOnTouchOutside = true
//        }
    }
    
    @IBAction func popBack(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
//    func textField(
//        _ textField: UITextField,
//        shouldChangeCharactersIn range: NSRange,
//        replacementString string: String
//        ) -> Bool {
//
//        if textField == loginPasswordTextfield {
//
//            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//
//            if !text.isEmpty {
//                loginBtn.isEnabled = true
//                loginBtn.backgroundColor = .Orange
//            } else {
//                loginBtn.isEnabled = false
//                loginBtn.backgroundColor = .B3
//            }
//
//        }
//
//        return true
//    }
}
