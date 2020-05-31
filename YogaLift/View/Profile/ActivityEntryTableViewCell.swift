//
//  ActivityEntryTableViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/10.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class ActivityEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var percentageLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(title: String, time: Int, percentage: Int, activityType: String) {
        
        timeLabel.text = "\(time)分鐘"
        
        titleLabel.text = title
        
        percentageLabel.text = "\(percentage)%"
        
        switch activityType {
        case "train": return colorView.backgroundColor = .init(red: 247/255, green: 122/255, blue: 37/255, alpha: 1)
        default: return colorView.backgroundColor = .G1
        }
        
    }

}
