//
//  PracticeVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class PracticeVC: UIViewController, UICollectionViewDelegate, UITableViewDelegate {

    @IBOutlet weak var progressCollectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var previousBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var workoutImageView: UIImageView!
    
    var workoutArray: [WorkoutSet]?
    
    var workoutIndex: Int = 0 {
        
        didSet {
            
            tableView.reloadData()
            
            progressCollectionView.reloadData()
            
            setupBtn()
            
            setupGifImage()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.lw_registerCellWithNib(
            identifier: String(describing: PracticeActivityInfoTableViewCell.self),
            bundle: nil)
        
        tableView.lw_registerCellWithNib(
            identifier: String(describing: SecondActivityInfoTableViewCell.self),
            bundle: nil)
        
        setupGifImage()
        
        setupBtn()

    }
    
    private func setupGifImage() {
        
        guard let workoutArray = workoutArray else { return }
        let currentWorkout = workoutArray[workoutIndex]
        workoutImageView.animationImages = [
            UIImage(named: currentWorkout.images[0]),
            UIImage(named: currentWorkout.images[1])
            ] as? [UIImage]
        
        workoutImageView.animationDuration = currentWorkout.perDuration
        workoutImageView.startAnimating()
        
    }
    
    private func setupBtn() {
        
        if workoutIndex > 0 {
            previousBtn.backgroundColor = .Orange
        } else {
            previousBtn.backgroundColor = .B3
        }
        
        if workoutIndex < 3 {
            nextBtn.backgroundColor = .Orange
        } else {
            nextBtn.backgroundColor = .B3
        }
        
    }
    
    @IBAction func previousBtnPressed(_ sender: UIButton) {
        
        nextBtn.isEnabled = true
        
        if workoutIndex > 0 {
            workoutIndex -= 1
            previousBtn.isEnabled = true
        } else {
            previousBtn.isEnabled = false
            
        }
        
    }
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        previousBtn.isEnabled = true
        
        if workoutIndex < 3 {
            workoutIndex += 1
            nextBtn.isEnabled = true
        } else {
            nextBtn.isEnabled = false
        }
        
    }
    
    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}

extension PracticeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: PracticeActivityInfoTableViewCell.self),
            for: indexPath
        )
        
        let cellReuse = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SecondActivityInfoTableViewCell.self),
            for: indexPath
        )
        
        guard let firstCell = cell as? PracticeActivityInfoTableViewCell else { return cell }
        
        guard let secondCell = cellReuse as? SecondActivityInfoTableViewCell else { return cell }
        
        guard let currentWorkout = workoutArray?[workoutIndex] else { return cell }
        
        if indexPath.row == 0 {
            
            firstCell.layoutView(title: currentWorkout.title, description: currentWorkout.description)
            
            return firstCell
            
        } else {
            
            guard let annotation = currentWorkout.annotation else { return UITableViewCell() }
            
            secondCell.layoutView(annotation: annotation[0])
            
            return secondCell
            
        }
    }
    
}

extension PracticeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let workoutArray = workoutArray else { return 0 }
        
        return workoutArray.count
    }
    
    // swiftlint:disable identifier_name
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = progressCollectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath)
        
        var background = [UIColor?]()
        
        for _ in 0...3 {
            background.append(.B5)
        }
        
        for i in 0...workoutIndex {
            background[i] = .Orange
        }
        
        cell.backgroundColor = background[indexPath.item]
        
        return cell
        
    }
    
}

extension PracticeVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let workoutCount = workoutSet?.count else { return CGSize() }
//        let workoutCountCGFlaot = CGFloat(workoutCount)
//        let cellWidth = (self.view.frame.width - (workoutCountCGFlaot - 1) * 2) / workoutCountCGFlaot
        let cellWidth = (self.view.frame.width - 6) / 4
        
        return CGSize(width: cellWidth, height: 5)
    }

}
