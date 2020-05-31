//
//  YinYogaSetupVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/6.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
//import Firebase
import SCLAlertView

class YinYogaSetupVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var workoutTimeLabel: UILabel!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {

        dismiss(animated: true)

    }

    @IBOutlet weak var navBarItem: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!
    
    let workoutElementManager = WorkoutElementManager()
    
    var workoutElement: WorkoutElement? {
        didSet {
            tableView.isHidden = false
            
            startBtn.isHidden = false
            
            tableView.reloadData()
            
            setupView()
        }
    }
    
    var idUrl: String?
    
    var recordYinYogaTime: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.lw_registerCellWithNib(
            identifier: String(describing: ActivitySetupTableViewCell.self),
            bundle: nil)
        
        guard let idUrl = idUrl else { return }
        
        if workoutElement == nil {
            tableView.isHidden = true
        }
        
        startBtn.isHidden = true
        
        workoutElementManager.getWorkoutElement(id: idUrl) { (workoutElement, error) in
            if let error = error {
                print(error)
            } else {
                self.workoutElement = workoutElement
            }
        }
        

    }
    
    private func setupView() {
        
        guard let workoutElement = workoutElement else { return }
        
        navBarItem.title = workoutElement.title
        
        iconImageView.image = UIImage(named: workoutElement.icon)
        
        descriptionLabel.text = workoutElement.description
        
        guard let time = workoutElement.time else { return }
        
        workoutTimeLabel.text = "\(time)分钟"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? YinYogaNavVC {
            
            guard let workoutElement = workoutElement else { return }
            
            desVC.workoutArray = workoutElement.workoutSet
            desVC.workoutMinutes = Float(workoutElement.time!)
            desVC.navTitle = workoutElement.title
        }
        
        if let practiceVC = segue.destination as? PracticeVC {
            practiceVC.workoutArray = workoutElement?.workoutSet
        }
    }
    
    @IBAction func unwindtoSetup(segue: UIStoryboardSegue) {
        
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
//        guard let user = Auth.auth().currentUser else { return }
        
        guard let workoutElement = workoutElement else { return }
        
        guard let recordYinYogaTime = recordYinYogaTime else { return }
        
        if recordYinYogaTime > 0 {
            
            LeanCloudService.shared.saveActivity("yinyoga", workoutElement.title, recordYinYogaTime) { (completion, error) in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Train Workout Time Document succesfully updated")
                }
            }
//            AppDelegate.db.collection("users").document(user.uid).collection("workout").addDocument(
//                data: [
//                    "activity_type": "yinyoga",
//                    "title": workoutElement.title,
//                    "workout_time": recordYinYogaTime,
//                    "created_time": time
//            ]) { (error) in
//                if let error = error {
//                    print("Error updating document: \(error)")
//                } else {
//                    print("YinYoga Workout Time Document succesfully updated")
//                }
//            }
            
            SCLAlertView().showSuccess("运动登录", subTitle: "太好了，完成 \(recordYinYogaTime) 分钟运动！")
        }
        
    }
}

extension YinYogaSetupVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitySetupTableViewCell", for: indexPath)
        
        guard let setupCell = cell as? ActivitySetupTableViewCell else { return cell }
        
        guard let workoutSet = workoutElement?.workoutSet[indexPath.row] else { return cell }
        
        setupCell.layoutView(image: workoutSet.thumbnail, title: workoutSet.title)

        return setupCell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

}
