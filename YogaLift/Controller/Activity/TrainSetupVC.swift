//
//  ActivitySetupViewController.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/6.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
//import Firebase
import SCLAlertView

class TrainSetupVC: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let workoutElementManager = WorkoutElementManager()
    
    var workoutElement: WorkoutElement? {
        didSet {
            startBtn.isHidden = false
            tableView.isHidden = false
            tableView.reloadData()
            setupView()
        }
    }
    
    var idUrl: String?
    
    var selectedTime: Float? {
        didSet {
            startBtn.isEnabled = true
            startBtn.backgroundColor = .Orange
        }
    }
    
    var selectedTimeWorkoutTitle: String?
    
    var recordTrainTime: Int?

    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {

        dismiss(animated: true)

    }
    
    @IBOutlet var timerBtns: [UIButton]!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func selectTimerPressed(_ sender: UIButton) {
        
        for btn in timerBtns {
            
            btn.isSelected = false
            
        }
        
        sender.isSelected = true
        
        selectTimer(withTag: sender.tag)
        
    }
    
    private func showTimeoutMsg() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )

        let timeoutValue: TimeInterval = 5.0
        let timeoutAction: SCLAlertView.SCLTimeoutConfiguration.ActionType = {

        }
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showWarning(
            "No button",
            subTitle: "Just wait for 3 seconds and I will disappear",
            timeout: SCLAlertView.SCLTimeoutConfiguration(timeoutValue: timeoutValue, timeoutAction: timeoutAction))
        
    }

    @IBOutlet weak var navBarItem: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.lw_registerCellWithNib(
            identifier: String(describing: ActivitySetupTableViewCell.self),
            bundle: nil)
        
        guard let idUrl = idUrl else { return }
        
        startBtn.isEnabled = false
        startBtn.isHidden = true
        
        if self.workoutElement == nil {
            tableView.isHidden = true
        }
        
        workoutElementManager.getWorkoutElement(id: idUrl) { (workoutElement, _ ) in
            self.workoutElement = workoutElement
        }
        
    }
    
    private func setupView() {
        
        guard let workoutElement = workoutElement else { return }
        
        navBarItem.title = workoutElement.title
        
        iconImageView.image = UIImage(named: workoutElement.icon)
        
        descriptionLabel.text = workoutElement.description
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? NavigationVC,
            let workoutMinutes = selectedTime {
            desVC.workoutMinutes = workoutMinutes
            desVC.workoutArray = workoutElement?.workoutSet
            desVC.navTitle = selectedTimeWorkoutTitle
        }
        
        if let practiceVC = segue.destination as? PracticeVC {
            practiceVC.workoutArray = workoutElement?.workoutSet
        }
    }
    
    private func selectTimer(withTag tag: Int) {
        
        if tag == 0 {
            selectedTime = 5.0
            selectedTimeWorkoutTitle = "5分钟肌力训练"
        } else if tag == 1 {
            selectedTime = 10.0
            selectedTimeWorkoutTitle = "10分钟肌力训练"
        } else if tag == 2 {
            selectedTime = 15.0
            selectedTimeWorkoutTitle = "15分钟肌力训练"
        }
        
    }
    
    @IBAction func unwindtoSetup(segue: UIStoryboardSegue) {
        
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
//        guard let user = Auth.auth().currentUser else { return }
        
        guard let workoutElement = workoutElement else { return }
        
        guard let recordTrainTime = recordTrainTime else { return }
        
        if recordTrainTime > 0 {
            self.recordTrainTime = recordTrainTime
            LeanCloudService.shared.saveActivity("train", workoutElement.title, recordTrainTime) { (completion, error) in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Train Workout Time Document succesfully updated")
                }
            }
            
//            AppDelegate.db.collection("users").document(user.uid).collection("workout").addDocument(
//                data: [
//                    "activity_type": "train",
//                    "title": workoutElement.title,
//                    "workout_time": recordTrainTime,
//                    "created_time": time
//            ]) { (error) in
//                if let error = error {
//                    print("Error updating document: \(error)")
//                } else {
//                    print("Train Workout Time Document succesfully updated")
//                }
//            }
            SCLAlertView().showSuccess("运动登录", subTitle: "太好了，完成 \(recordTrainTime) 分钟运动！")
        }
    }
}

extension TrainSetupVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutElement?.workoutSet.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitySetupTableViewCell", for: indexPath)
        
        guard let setupCell = cell as? ActivitySetupTableViewCell else { return cell }
        
        guard let workoutSet = workoutElement?.workoutSet[indexPath.row] else { return cell }
        
        setupCell.layoutView(image: workoutSet.thumbnail, title: workoutSet.title)

        return setupCell

    }

}
