//
//  ActivityCollectionViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/2.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var workoutIcon: UIImageView!

    @IBOutlet weak var workoutLabel: UILabel!

//    func layoutView(title: String, image: UIImage?) {
//
//        workoutLabel.text = title
//
//        workoutIcon.image = image
//
//    }
    
    func layoutView(title: String, image: String) {
        
        workoutLabel.text = title
        
        workoutIcon.image = UIImage(named: image)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
