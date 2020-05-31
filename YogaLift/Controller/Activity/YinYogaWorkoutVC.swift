//
//  YinYogaWorkoutVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/24.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
import AVFoundation

// swiftlint:disable identifier_name
class YinYogaWorkoutVC: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var repeatCollectionView: UICollectionView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    @IBOutlet weak var workoutImageView: UIImageView!
    
    @IBOutlet weak var soundBtn: UIButton!
    
    var navTitle: String?
    
    var barTimer: Timer?
    
    var repeatTimer: Timer?
    
    var counter = 1
    
    var workoutArray: [WorkoutSet]?
    
    var workoutIndex = 0
    
    var repeatCountingText = [String]()
    
    var currentRepeat = 1
    
    var workoutMinutes: Float? = 5
    
    var currentTime: Float = 0.0 {
        
        didSet {
            print(currentTime)
        }
        
    }
    
    var soundIsOn: Bool = true // offIcon -> selected
    
    @IBAction func toggleSonudBtnPressed(_ sender: UIButton) {
        
        soundIsOn = !soundIsOn
        
        if soundIsOn == true {
            
            doneAudioPlayer.volume = 1
            
            keepAudioPlayer.volume = 1
            
            soundBtn.isSelected = true // onIcon -> default
            
        } else {
            
            doneAudioPlayer.volume = 0
            
            keepAudioPlayer.volume = 0
            
            soundBtn.isSelected = false
            
        }
        
    }
    
    var keepAudioPlayer = AVAudioPlayer()
    
    var doneAudioPlayer = AVAudioPlayer()
    
    var countSoundFileName = 1
    
    var doneCounting = 1
    
    private func setAndPlayCountSound(soundFile: Int) {
        
        let sound = Bundle.main.path(forResource: "Keep", ofType: "mp3")
        
        do {
            try keepAudioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print(error)
        }
        
        keepAudioPlayer.play()
        
        if soundIsOn == true {
            
            keepAudioPlayer.volume = 1
            
        } else {
            
            keepAudioPlayer.volume = 0
        }
    }
    
    private func setupDoneAudioPlayer() {
        
        let sound = Bundle.main.path(forResource: "DonePerCount", ofType: "mp3")
        
        do {
            try doneAudioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print(error)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        navigationItem.title = navTitle
        
        setupDoneAudioPlayer()
        
        setAndPlayCountSound(soundFile: self.countSoundFileName)
        
        countSoundFileName += 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        changeTitleAndRepeatText()
        
        updateBarProgress()
        
        guard let workoutArray = workoutArray else { return }
        let currentWorkout = workoutArray[workoutIndex]
        workoutImageView.image = UIImage(named: currentWorkout.images[1])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        repeatTimer?.invalidate()
        barTimer?.invalidate()
        
        repeatCountingText = [String]()
        
        doneAudioPlayer.pause()
        keepAudioPlayer.pause()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let workoutMinutes = workoutMinutes else { return }
        let maxTime = workoutMinutes * 60.0
        if let destination = segue.destination as? YinYogaCountdownVC {
            destination.currentTime = self.currentTime
//            destination.maxTime = maxTime
        }
        
        if let pauseVC = segue.destination as? PauseVC {
            pauseVC.currentTime = self.currentTime
            pauseVC.maxTime = maxTime
            pauseVC.workoutArray = workoutArray
            pauseVC.workoutIndex = workoutIndex
        }
        
        if let finishVC = segue.destination as? FinishWorkoutVC {
            finishVC.currentTime = self.currentTime
        }
        
        if let prepareVC = segue.destination as? YinYogaPrepareVC {
            prepareVC.currentTime = currentTime
            currentRepeat += 1
            prepareVC.currentRepeat = currentRepeat
            prepareVC.repeatCollectionView.reloadData()
            
        }
    }
    
    private func changeTitleAndRepeatText() {
        
        guard let workoutArray = workoutArray else { return }
        
        let currentWorkout = workoutArray[workoutIndex]
        
        workoutTitleLabel.text = currentWorkout.title
        infoLabel.text = currentWorkout.hint
        
        counter = workoutArray[workoutIndex].count
        countDownLabel.text = "00:\(String(format: "%02d", self.counter))"
        
        changeRepeatCounts(totalCount: currentWorkout.count, timeInterval: currentWorkout.perDuration)
        
        repeatCollectionView.reloadData()
        
    }
    
    private func changeRepeatCounts(totalCount: Int, timeInterval: TimeInterval) {
        
        repeatTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            
            if self.counter > 0 {
                self.counter -= 1
                self.countDownLabel.text = "00:\(String(format: "%02d", self.counter))"
//                progressView.value = CGFloat(30 - counter)
                
            } else {
                
                // 進入下一個 rep
                self.repeatTimer?.invalidate()
                self.barTimer?.invalidate()
                self.moveToNextVC()
                
                guard let workoutArray = self.workoutArray else { return }
                
                // 判斷是否完成所有的rep
                if self.currentRepeat < workoutArray[self.workoutIndex].workoutSetRepeat {
//                    self.currentRepeat += 1
                    
                    self.counter = 1
                    self.changeTitleAndRepeatText()
                    
                    self.updateBarProgress()
                    
                    self.doneCounting = 1
                    
                    self.countSoundFileName = 1
                    self.setAndPlayCountSound(soundFile: self.countSoundFileName)
                    self.countSoundFileName += 1
                    
                } else {
                    // 完成一個動作的所有rep，換下一個動作
//                    self.workoutIndex += 1
                    self.currentRepeat = 1
                
                }
                
            }
            
        })
        
    }
    
    private func updateBarProgress() {
        
        guard let workoutMinutes = workoutMinutes else { return }
        let maxTime = workoutMinutes * 60.0
        
        currentTime += 1.0
        barProgressView.progress = self.currentTime/maxTime
        
        barTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            if self.currentTime < maxTime {
                self.currentTime += 1.0
                self.barProgressView.progress = self.currentTime/maxTime
            } else {
                return
            }
        })
    }
    
    private func moveToNextVC() {
        
        guard let workoutArray = workoutArray else { return }
        
        if currentRepeat == workoutArray[workoutIndex].workoutSetRepeat && workoutIndex == (workoutArray.count - 1) {
            performSegue(withIdentifier: "finishYinYoga", sender: self)
        } else if currentRepeat == workoutArray[workoutIndex].workoutSetRepeat {
            performSegue(withIdentifier: "unwindToCountdown", sender: self)
            self.loadViewIfNeeded()
        } else {
            performSegue(withIdentifier: "unwindToPrepare", sender: self)
        }
        
    }
    
}

extension YinYogaWorkoutVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let workoutArray = workoutArray else { return 0 }
        
        return workoutArray[workoutIndex].workoutSetRepeat
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = repeatCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RepeatCollectionViewCell.self),
            for: indexPath
        )
        
        guard let repeatCell = cell as? RepeatCollectionViewCell else { return cell }
        
        var bgColorArray = [UIColor?]()
        var textColorArray = [UIColor?]()
        guard let workoutArray = workoutArray else { return cell }
        
        for _ in 0..<workoutArray[workoutIndex].workoutSetRepeat {
            let defaultViewColor = UIColor.B5
            bgColorArray.append(defaultViewColor)
            
            let defaultTextColor = UIColor.B1
            textColorArray.append(defaultTextColor)
        }
        
        for i in 0..<currentRepeat {
            let finishedViewColor = UIColor.G2
            bgColorArray[i] = finishedViewColor
            
            let finishedTextColor = UIColor.white
            textColorArray[i] = finishedTextColor
        }
        
        repeatCell.counterLabel.text = String(indexPath.item + 1)
        repeatCell.counterLabel.textColor = textColorArray[indexPath.item]
        repeatCell.cellBackground.backgroundColor = bgColorArray[indexPath.item]
        
        return repeatCell
    }
    
}

extension YinYogaWorkoutVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        guard let workoutArray = workoutArray else { return CGSize() }
        let collectionViewWidth = repeatCollectionView.bounds.width
        let cellSpace = Int(collectionViewWidth) / workoutArray[workoutIndex].workoutSetRepeat
        return CGSize(width: cellSpace, height: 25)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }
    
}
