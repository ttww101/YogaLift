//
//  UICollectionView+Extension.swift
//   WorkOutLift
//
//  Created by Jo Yun Hsu on 2019/5/13.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func lw_registerCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: identifier)
        
    }
    
}
