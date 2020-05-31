//
//  SecondActivityInfoTableViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/7.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class SecondActivityInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var annotationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(annotation: String) {
        
        annotationLabel.text = annotation
        
    }

}
