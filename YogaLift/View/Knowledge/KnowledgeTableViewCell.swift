//
//  KnowledgeTableViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class KnowledgeTableViewCell: UITableViewCell {
    
    var isMarked: Bool = false
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var underlineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(category: String, title: String) {
        
        var categoryText: String {
            switch category {
            case "food": return "饮食"
            case "workout": return "运动"
            default: return "脂肪肝"
            }
        }
        
        self.categoryLabel.text = categoryText
        
        self.titleLabel.text = title
        
        var categoryColor: UIColor? {
            switch category {
            case "food": return UIColor.G1
            case "workout": return UIColor.Orange
            default: return UIColor.Yellow
            }
        }
        
        self.underlineView.backgroundColor = categoryColor
        
        self.categoryLabel.textColor = categoryColor
        
    }

}
