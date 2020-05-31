//
//  SignUpThirdViewController.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class CurrentWeightVC: STBaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var currentWeightTextfield: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var signupEmail: String?
    
    var signupPassword: String?
    
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeightTextfield.delegate = self
        
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .B3

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let desVC = segue.destination as? ExpectedWeightVC {
            desVC.signupEmail = signupEmail
            desVC.signupPassword = signupPassword
            desVC.userName = userName
            desVC.currentWeight = currentWeightTextfield.text!
        }
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = .B1
        } else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = .B3
        }
        
        return true
        
    }
    
}
