//
//  SignupSecondViewController.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class UserNameVC: STBaseVC, UITextFieldDelegate {
    
    var signupEmail: String?
    
    var signupPassword: String?
    
    @IBOutlet weak var signupNameTextfield: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        if self.signupNameTextfield.text == "" {
            self.customAlert("请输入用户名称")
            return
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupNameTextfield.delegate = self
        
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .B3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let desVC = segue.destination as? CurrentWeightVC {
            desVC.signupEmail = signupEmail
            desVC.signupPassword = signupPassword
            desVC.userName = signupNameTextfield.text
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
    
    func customAlert(_ message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "确定", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }

}
