//
//  HomeVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import MKProgress

class HomeVC: LWBaseVC, UICollectionViewDelegate, HomeManagerDelegate {

    @IBOutlet weak var suggestTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var statusRemainTimeLabel: UILabel!
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var trainProgressView: MBCircularProgressBarView!

    @IBOutlet weak var yinyogaProgressView: MBCircularProgressBarView! // 後面、加總
    
    @IBOutlet weak var todayWorkoutTimeLabel: UILabel!

    @IBOutlet weak var workoutCollectionView: UICollectionView!

    @IBOutlet weak var weekProgressCollectionView: UICollectionView!
    
    @IBOutlet weak var stillRemainLabel: UILabel!
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    var todayDate = ""
    
    lazy var homeManager: HomeManager = {
        
        let model = HomeManager()
        
        model.delegate = self
        
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareBtn.isEnabled = false

        ProgressHud.showProgressHud()
        
        if UIScreen.main.nativeBounds.height == 1136 {
            
            statusRemainTimeLabel.isHidden = true
            
        }
        
    }
    
    override func getData() {
        
        homeManager.activate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        homeManager.reset()
    }
    
    // MARK: - HomeManagerDelegate
    
    func didGet(date: String, homeObject: HomeObject, description: String) {
        
        timeLabel.text = date
        
        statusLabel.text = homeObject.title
        
        statusRemainTimeLabel.text = description
        
        background.image = UIImage(named: homeObject.background)
        
        workoutCollectionView.reloadData()
        
    }
    
    func didGet(todayTrainTime: Int, todayYinYogaTime: Int) {
        
        let totalWorkoutTime = todayTrainTime + todayYinYogaTime

        todayWorkoutTimeLabel.text = "\(totalWorkoutTime)"

        UIView.animate(withDuration: 0.5) {
            if totalWorkoutTime >= 20 {
                self.yinyogaProgressView.value = 20
                self.trainProgressView.value = CGFloat(integerLiteral: todayTrainTime * 20 / totalWorkoutTime)
            } else {
                self.yinyogaProgressView.value = CGFloat(totalWorkoutTime)
                self.trainProgressView.value = CGFloat(integerLiteral: todayTrainTime)
            }
        }

        if totalWorkoutTime >= 20 {
            stillRemainLabel.text = "太棒了"
            remainingTimeLabel.text = "達成目標"
        } else {
            stillRemainLabel.text = "還差"
            remainingTimeLabel.text = "\(20 - totalWorkoutTime)分鐘"
        }

        weekProgressCollectionView.reloadData()
        
        self.shareBtn.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let trainWorkoutTime = homeManager.trainWorkoutTime

        let yinyogaWorkoutTime = homeManager.yinyogaWorkoutTime

        let totalWorkoutTime = yinyogaWorkoutTime + trainWorkoutTime

        if let desVC = segue.destination as? ShareVC {
            
            desVC.dailyValue = homeManager.homeProvider.dailyValue
            
            desVC.loadViewIfNeeded()
            
            desVC.todayTotalTimeLabel.text = "\(totalWorkoutTime)"
            
            desVC.trainTimeLabel.text = "\(trainWorkoutTime)分鐘"
            
            desVC.yinyogaTimeLabel.text = "\(yinyogaWorkoutTime)分鐘"
            
            desVC.todayDateLabel.text = todayDate

            if totalWorkoutTime >= 20 {
                
                    desVC.yinyogaProgressView.value = 20
                
                    desVC.trainProgressView.value = CGFloat(integerLiteral: trainWorkoutTime * 20 / totalWorkoutTime)
                
            } else {
                
                    desVC.yinyogaProgressView.value = CGFloat(totalWorkoutTime)
                
                    desVC.trainProgressView.value = CGFloat(integerLiteral: trainWorkoutTime)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if collectionView == workoutCollectionView {

            guard let homeObject = homeManager.homeObject else { return }

            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)

            if homeObject.status == "resting" {

                let desVC = mainStoryboard.instantiateViewController(withIdentifier: "TrainSetupVC")
                guard let trainVC = desVC as? TrainSetupVC else { return }
                trainVC.idUrl = homeObject.workoutSet[indexPath.item].id
                self.present(trainVC, animated: true)

            } else {

                let desVC = mainStoryboard.instantiateViewController(withIdentifier: "YinYogaSetupVC")
                guard let yinyogaVC = desVC as? YinYogaSetupVC else { return }
                yinyogaVC.idUrl = homeObject.workoutSet[indexPath.item].id
                self.present(yinyogaVC, animated: true)

            }
        }
    }
}

extension HomeVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == workoutCollectionView {

            guard let workoutSet = homeManager.homeObject?.workoutSet else { return 0 }

            return workoutSet.count

        } else if collectionView == weekProgressCollectionView {

            return 7

        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == workoutCollectionView {

            let cell = workoutCollectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: HomeCollectionViewCell.self),
                for: indexPath)

            guard let homeCell = cell as? HomeCollectionViewCell else { return cell }

            guard let workoutElement = homeManager.homeObject?.workoutSet[indexPath.row] else { return cell }

            homeCell.layoutCell(image: workoutElement.buttonImage)

            return homeCell

        } else if collectionView == weekProgressCollectionView {

            let days = ["ㄧ", "二", "三", "四", "五", "六", "日"]

            let cell = weekProgressCollectionView.dequeueReusableCell(
                withReuseIdentifier: "WeekProgressCollectionViewCell", for: indexPath)

            guard let progressCell = cell as? WeekProgressCollectionViewCell else { return cell }

            progressCell.dayLabel.text = days[indexPath.item]
            
            progressCell.layoutView(value: homeManager.dailyValue[indexPath.item])

            return progressCell

        }

        return UICollectionViewCell()
    }

}

extension HomeVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == workoutCollectionView {

            return CGSize(width: 165, height: 119)

        } else {

            return CGSize(width: 20, height: 40)

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == weekProgressCollectionView {

            return 21

        } else {

            return 0

        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        if collectionView == workoutCollectionView {
            
            let height = CGFloat(119) // collectionView.visibleCells[0].frame.height
            
            let viewHeight = collectionView.frame.size.height
            
            let toBottomUp = viewHeight - height

            return UIEdgeInsets(top: 0, left: 16, bottom: toBottomUp, right: 0)

        } else {

            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }

    }

}
