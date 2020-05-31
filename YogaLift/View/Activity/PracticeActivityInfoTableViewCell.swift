//
//  PracticeActivityInfoTableViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/7.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class PracticeActivityInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(title: String, description: String) {
        
        titleLabel.text = title
        
        descriptionLabel.text = description
        
    }

}
