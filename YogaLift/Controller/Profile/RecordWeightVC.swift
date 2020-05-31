//
//  RecordWeightVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/22.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
////import Firebase
import LeanCloud
import IQKeyboardManagerSwift

class RecordWeightVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var reloadDataAfterUpdate: (() -> Void)?
    
    var weightDocumentID: String?
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日"
        let convertedDate = dateFormatter.string(from: today)
        
        guard LeanCloudService.shared.objectId != "" else { return }

        guard let weightText = textField.text else { return }
        
//        let weightRef = AppDelegate.db.collection("users").document(user.uid).collection("weight")
        
        let weight = Double(weightText)
        
        if let weightDocumentID = weightDocumentID {
            
            let cql = "update Weight set weight=\(weight!) where objectId='\(LeanCloudService.shared.objectId)'"
            
            _ = LCCQLClient.execute(cql) { result in
                switch result {
                case .success(let result):
                    print("Document succesfully updated")
                case .failure(let error):
                    print("Error updating document: \(error)")
                }
            }
            
            // Update document without overwriting
//            weightRef.document(weightDocumentID).updateData([
//                "weight": weight!
//            ]) { (error) in
//                if let error = error {
//                    print("Error updating document: \(error)")
//                } else {
//                    print("Document succesfully updated")
//                }
//            }
            
        } else {
            
            // create new document
            let weightData: [String: Any] = [
                "weight": weight!,
                "created_time": time
            ]
            do {
                let todo = LCObject(className: "Weight")
                try todo.set("weight", value: weight!)
                try todo.set("userid", value: LeanCloudService.shared.objectId)
                let _ = todo.save { (result) in
                    switch result {
                    case .success:
                        print("Weight document successfully written!")
                    case .failure(error: let error):
                        print("Error writing document: \(error)")
                    }
                }
            } catch {
                // handle error
            }
            
//            weightRef.document(convertedDate).setData(weightData) { (err) in
//                if let err = err {
//                    print("Error writing document: \(err)")
//                } else {
//                    print("Weight document successfully written!")
//                }
//            }
            
        }
        
        guard let closure = reloadDataAfterUpdate else { return }

        closure()
        
        dismiss(animated: true)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = .G1
        } else {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = .B3
        }
        
        return true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        confirmBtn.isEnabled = false
        confirmBtn.backgroundColor = .B3
        
        if weightDocumentID != nil {
            titleLabel.text = "修改体重"
        } else {
            titleLabel.text = "新增体重"
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        weightDocumentID = nil
    }

}
