//
//  PieChartTableViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class PieChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    @IBOutlet weak var yinyogaLabel: UILabel!
    
    @IBOutlet weak var trainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(trainSum: Int, yinyogaSum: Int) {
        
        let totalSum = trainSum + yinyogaSum
        
        if totalSum != 0 {
            
            let trainProportion = lround(Double(trainSum * 100 / totalSum))
            
            let yinyogaProportion = 100 - trainProportion
            
            progressView.value = CGFloat(trainSum * 100 / totalSum)
            
            yinyogaLabel.text = "\(yinyogaProportion)%"
            
            trainLabel.text = "\(trainProportion)%"
            
        } else {
            
            return
            
        }
        
    }

}
