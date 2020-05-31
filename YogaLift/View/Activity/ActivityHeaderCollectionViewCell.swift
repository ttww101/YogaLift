//
//  ActivityHeaderCollectionViewCell.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class ActivityHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var crossImage: UIImageView!

    @IBOutlet weak var firstLineLabel: UILabel!

    @IBOutlet weak var secondLineLabel: UILabel!

    @IBOutlet weak var captionLabel: UILabel!

    @IBOutlet weak var roundCornerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func layoutCell(firstLine: String, secondLine: String, caption: String, crossImage: UIImage, corner: UIRectCorner) {

        self.crossImage.image = crossImage

        firstLineLabel.text = firstLine

        secondLineLabel.text = secondLine

        captionLabel.text = caption

        roundCorners(roundCornerView, corner, radius: 50)

    }
    
    func roundCorners(_ view: UIView, _ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: view.bounds.height)),
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }

}
