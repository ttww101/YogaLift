//
//  KingFisherWrapper.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String, placeholder: UIImage? = nil) {
        
        let url = URL(string: urlString)
        
        self.kf.setImage(with: url, placeholder: placeholder)
        
    }
    
}
