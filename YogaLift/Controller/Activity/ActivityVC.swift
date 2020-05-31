//
//  ActivityVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/2.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class ActivityVC: LWBaseVC, UICollectionViewDelegate, UIScrollViewDelegate {
    
    deinit {
        print("ActivityVC deinit")
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!

    @IBOutlet var orderBtns: [UIButton]!

    var tableViews: [UICollectionView] {

        return [firstCollectionView, secondCollectionView]

    }

    let manager = ActivityManager()
    
    let workoutManager = WorkoutManager()
    
    var trainElements: [WorkoutElement]? {
        didSet {
            firstCollectionView.reloadData()
        }
    }
    
    var yinyogaElements: [WorkoutElement]? {
        didSet {
            secondCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutManager.getWorkout(activity: ActivityItems.train) { [weak self] (train, _ ) in
            self?.trainElements = train
        }
        
        workoutManager.getWorkout(activity: ActivityItems.yinyoga) { [weak self] (yinyoga, _ ) in
            self?.yinyogaElements = yinyoga
        }

        scrollView.delegate = self
        
        firstCollectionView.lw_registerCellWithNib(
            identifier: String(describing: ActivityHeaderCollectionViewCell.self),
            bundle: nil)
        
        secondCollectionView.lw_registerCellWithNib(
            identifier: String(describing: ActivityHeaderCollectionViewCell.self),
            bundle: nil)
        
        firstCollectionView.lw_registerCellWithNib(
            identifier: String(describing: ActivityCollectionViewCell.self),
            bundle: nil)
        
        secondCollectionView.lw_registerCellWithNib(
            identifier: String(describing: ActivityCollectionViewCell.self),
            bundle: nil)

        self.navigationController?.isNavigationBarHidden = true

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

        UIView.animate(withDuration: 0.3) {

            self.scrollView.contentOffset.x = CGFloat(toPage) * screenWidth

            self.view.layoutIfNeeded()

        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let screenWidth  = UIScreen.main.bounds.width

        indicatorLeadingConstraint.constant = scrollView.contentOffset.x / 2

        let temp = Double(scrollView.contentOffset.x / screenWidth)

        let number = lround(temp)

        for btn in orderBtns {

            btn.isSelected = false

        }
        
        if number < 2 && number >= 0 {
            
            orderBtns[number].isSelected = true
            
            UIView.animate(withDuration: 0.1) {
                
                self.view.layoutIfNeeded()
                
            }
            
        }

    }
    
    var collectinNum = 0
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section == 1 {

            if collectionView == firstCollectionView {
                collectinNum = 1
                performSegue(withIdentifier: "setupYinYoga", sender: nil)

            } else {
                collectinNum = 2
                performSegue(withIdentifier: "setupYinYoga", sender: nil)

            }

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let trainDestination = segue.destination as? TrainSetupVC {

            var indexPath = self.firstCollectionView.indexPathsForSelectedItems?.first
            
            guard let trainElements = trainElements else { return }
            
            let passItem = trainElements[indexPath!.row]
            
            trainDestination.idUrl = passItem.id
            
        }

        if let yinyogaDestination = segue.destination as? YinYogaSetupVC {
            if self.collectinNum == 1 {var indexPath = self.firstCollectionView.indexPathsForSelectedItems?.first
                
                guard let trainElements = trainElements else { return }
                
                let passItem = trainElements[indexPath!.row]
                
                yinyogaDestination.idUrl = passItem.id
            } else {
                var indexPath = self.secondCollectionView.indexPathsForSelectedItems?.first
                
                guard let yinyogaElements = yinyogaElements else { return }
                
                let passItem = yinyogaElements[indexPath!.row]
                
                yinyogaDestination.idUrl = passItem.id
            }
            
            self.collectinNum = 0

        }

    }

}

extension ActivityVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            switch collectionView {
                
            case firstCollectionView: return trainElements?.count ?? 0
                
            case secondCollectionView: return yinyogaElements?.count ?? 0
                
            default: return 0
                
            }
            
        }
        
    }
    
    func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ActivityHeaderCollectionViewCell",
                for: indexPath
            )
            
            guard let headerCell = cell as? ActivityHeaderCollectionViewCell else { return cell }
            
            let trainGroup = manager.trainGroup
            let yinyogaGroup = manager.yinyogaGroup
            if collectionView == firstCollectionView {
                
                headerCell.layoutCell(
                    firstLine: trainGroup.firstLineTitle,
                    secondLine: trainGroup.secondLineTitle,
                    caption: trainGroup.caption,
                    crossImage: #imageLiteral(resourceName: "Image_OrangeCross.png"),
                    corner: .bottomLeft
                )
                
            } else {
                
                headerCell.layoutCell(
                    firstLine: yinyogaGroup.firstLineTitle,
                    secondLine: yinyogaGroup.secondLineTitle,
                    caption: yinyogaGroup.caption,
                    crossImage: #imageLiteral(resourceName: "Image_GreenCross"),
                    corner: .bottomRight
                )
                
            }
            
            return headerCell
            
        } else {
            
            if collectionView == firstCollectionView {
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ActivityCollectionViewCell",
                    for: indexPath
                )
                
                guard let trainCell = cell as? ActivityCollectionViewCell else { return cell }
                
                guard let trainElements = trainElements else { return cell }
                
                let trainItems = trainElements[indexPath.row]
                
                trainCell.layoutView(title: trainItems.title, image: trainItems.icon)
                
                return trainCell
                
            } else if collectionView == secondCollectionView {
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ActivityCollectionViewCell",
                    for: indexPath
                )
                
                guard let yinyogaCell = cell as? ActivityCollectionViewCell else { return cell }
                
                guard let yinyogaElements = yinyogaElements else { return cell }
                
                let yinyogaItems = yinyogaElements[indexPath.row]
                
                yinyogaCell.layoutView(title: yinyogaItems.title, image: yinyogaItems.icon)
                
                return yinyogaCell
                
            }
            
            return UICollectionViewCell()
            
        }
        
    }
    
}

extension ActivityVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {

            return CGSize(width: view.frame.width, height: 166)

        } else {

            switch collectionView {

            case firstCollectionView: return CGSize(width: (firstCollectionView.bounds.width - 20) / 2.0, height: 152.0)

            default: return CGSize(width: (secondCollectionView.bounds.width - 20) / 2.0, height: 152.0)

            }

        }

    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 26
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
        ) -> UIEdgeInsets {

        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        }

    }

}
