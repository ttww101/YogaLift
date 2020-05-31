//
//  SIgnUpFirstViewController.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import LeanCloud

class SignUpVC: STBaseVC, UITextFieldDelegate, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var signupEmailTextField: UITextField!
    
    @IBOutlet weak var signupPasswordTextfield: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var attributedLabel: TTTAttributedLabel!
    
    var userName: String?
    
    var currentWeight: String?
    
    var expectedWeight: String?
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
        if self.signupEmailTextField.text == "" || self.signupPasswordTextfield.text == "" {
            self.customAlert("請輸入email和密碼")
            return
        } else {
            guard let email = signupEmailTextField.text,
                let password = signupPasswordTextfield.text,
                let userName = userName,
                let goalWeight = Double(expectedWeight!),
                let nowWeight = Double(currentWeight!) else { return }
            
            LeanCloudService.shared.createUser(username: userName, account: email, password: password, nowWeight: nowWeight, goalWeight: goalWeight) { (completion, message, error) in
                if completion {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
                } else {
                    self.customAlert(message)
                    return
                }
            }
         
//            FIRFirestoreService.shared.createUser(email: email, password: password) { (_, error) in
//                
//                // 註冊失敗
//                if error != nil {
//                    self.customAlert((error?.localizedDescription)!)
//                    return
//                }
//                
//                // 註冊成功並顯示已登入
//                self.customAlert("已登入")
//                self.createUserDocument()
//            }
            
        }
        
    }
    
//    private func createUserDocument() {
//
//        guard let userName = userName else { return }
//
//        let today = Date()
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy年M月d日"
//        let convertedDate = dateFormatter.string(from: today)
//
//        guard let expectedWeightDouble = Double(expectedWeight!),
//            let initialWeightDouble = Double(currentWeight!) else { return }
//
//        let userDefaults = UserDefaults.standard
//        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
//
//        let createUser = [
//            "name": userName,
//            "signup_time": today,
//            "expected_weight": expectedWeightDouble,
//            "initial_weight": initialWeightDouble
//            ] as [String: Any]
//
//        FIRFirestoreService.shared.create(with: createUser) { (error) in
//            if let error = error {
//                print("Error writing user document: \(error)")
//            } else {
//                print("User document succesfully written!")
//                self.addInitialWeight(uid: uid, convertedDate: convertedDate, time: today)
//            }
//        }
//    }
    
//    private func addInitialWeight(uid: String, convertedDate: String, time: Date) {
//
//        let weightData = [
//            "weight": Double(currentWeight!) as Any,
//            "created_time": time
//            ] as [String: Any]
//
//        FIRFirestoreService.shared.create(with: weightData, in: .weight, documentID: convertedDate) { (error) in
//            if let error = error {
//                print("Error add initial weight to document: \(error)")
//            } else {
//                print("Add initial weight to document successfully")
//            }
//        }
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupPasswordTextfield.delegate = self
        
        startBtn.isEnabled = false
        startBtn.backgroundColor = .B3
        
        setupHyperText()

    }
    
    private func setupHyperText() {
        
        attributedLabel.numberOfLines = 0
        let strPP = "隐私权条款"
        let string = "点击开始的同时，表示您同意 WorkOutLift 的\(strPP)"
        let nsString = string as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        
        let fullAttributedString = NSAttributedString(string: string, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.B1!.cgColor
            ])
        attributedLabel.textAlignment = .center
        attributedLabel.attributedText = fullAttributedString
        
        let rangePP = nsString.range(of: strPP)
        
        let ppLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.Orange!.cgColor,
            NSAttributedString.Key.underlineStyle.rawValue: false
        ]
        let ppActiveLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.Orange!.cgColor,
            NSAttributedString.Key.underlineStyle.rawValue: false
        ]
        
        attributedLabel.activeLinkAttributes = ppActiveLinkAttributes
        attributedLabel.linkAttributes = ppLinkAttributes
        
        let urlPP = URL(string: "https://www.privacypolicies.com/privacy/view/9a5b8e0778b9b54af6b7ac3c386b0095")!

        attributedLabel.addLink(to: urlPP, with: rangePP)
        
        attributedLabel.textColor = UIColor.lightGray
        attributedLabel.delegate = self
        
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == "https://www.privacypolicies.com/privacy/view/9a5b8e0778b9b54af6b7ac3c386b0095" {
            print("PP click")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            startBtn.isEnabled = true
            startBtn.backgroundColor = .Orange
        } else {
            startBtn.isEnabled = false
            startBtn.backgroundColor = .B3
        }
        
        return true
        
    }
    
    func customAlert(_ message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }

}
