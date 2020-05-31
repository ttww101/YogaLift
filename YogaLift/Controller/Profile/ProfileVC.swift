//
//  ProfileVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
//import Firebase

class ProfileVC: LWBaseVC, UIScrollViewDelegate {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var weightContainerView: UIView!

    @IBOutlet var orderBtns: [UIButton]!

    var containerViews: [UIView] {

        return [statusContainerView, weightContainerView]

    }
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: "登出帐户", message: "确定要从帐户登出？", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "登出", style: .default) { [weak self] (_) in
            LeanCloudService.shared.clearObjectId()
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)

            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
            self?.dismiss(animated: true, completion: nil)
//            if Auth.auth().currentUser != nil {
//                do {
//                    try Auth.auth().signOut()
//                    self?.dismiss(animated: true, completion: nil)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { [weak self] (_) in
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        optionMenu.addAction(logoutAction)
        
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
    }
    
    override func getData() {
        
        getUserName()
    }
    
    private func getUserName() {
        
        LeanCloudService.shared.getUserName { (name, error) in
            if name != "" {
                self.userNameLabel.text = name
            } else {
                print("Document does not exist: \(String(describing: error))")
            }
        }
        
//        guard let user = Auth.auth().currentUser else { return }
//        
//        let userRef = AppDelegate.db.collection("users").document(user.uid)
//        
//        userRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let name = document.get("name")
//                guard let parsedName = name as? String else { return }
//                self.userNameLabel.text = parsedName
//            } else {
//                print("Document does not exist: \(String(describing: error))")
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func changePagePressed(_ sender: UIButton) {

        for btn in orderBtns {

            btn.isSelected = false

        }

        sender.isSelected = true

        moveIndicatorView(toPage: sender.tag)

    }

    private func moveIndicatorView(toPage: Int) {

        let screenWidth  = UIScreen.main.bounds.width

        indicatorLeadingConstraint.constant = CGFloat(toPage) * screenWidth / 2

        UIView.animate(withDuration: 0.3, animations: { [weak self] in

            self?.scrollView.contentOffset.x = CGFloat(toPage) * screenWidth

            self?.view.layoutIfNeeded()

        })

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let screenWidth  = UIScreen.main.bounds.width

        indicatorLeadingConstraint.constant = scrollView.contentOffset.x / 2

        let temp = Double(scrollView.contentOffset.x / screenWidth)

        let number = lround(temp)

        for btn in orderBtns {

            btn.isSelected = false

        }

        orderBtns[number].isSelected = true

        UIView.animate(withDuration: 0.1, animations: { [weak self] in

            self?.view.layoutIfNeeded()

        })

    }

}
