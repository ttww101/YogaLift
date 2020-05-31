//
//  DetailKnowledgeVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

class DetailKnowledgeVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var knowledge: Knowledge?
    
    var isMarked: Bool = false
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
//        dismiss(animated: true)
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = knowledge?.title
        
        contentLabel.text = knowledge?.content
        
//        self.navigationController?.isNavigationBarHidden = true

    }

}
