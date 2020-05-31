//
//  ActivitySetupTableViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/7.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class ActivitySetupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    
    @IBOutlet weak var exerciseTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(image: String, title: String) {
        
        exerciseTitle.text = title
        
        exerciseImageView.image = UIImage(named: image)
        
    }

}
