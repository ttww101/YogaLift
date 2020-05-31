//
//  HomeCollectionViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func layoutCell(image: String) {

        imageView.image = UIImage(named: image)

    }

}
