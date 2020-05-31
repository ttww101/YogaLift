//
//  WeekProgressCollectionViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/7.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class WeekProgressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var progressView: MBCircularProgressBarView!

    @IBOutlet weak var completeImage: UIImageView!
    
    func layoutView(value: Int) {
        
        if value == 0 {
            progressView.isHidden = true
            completeImage.image = UIImage(named: "Icon_Home_NoValue")
            return
        } else if value >= 20 {
            progressView.isHidden = true
            completeImage.image = UIImage(named: "Icon_Home_Complete")
        } else {
            progressView.isHidden = false
            progressView.value = CGFloat(integerLiteral: value)
        }
        
    }

}
