//
//  Double+Extension.swift
//   WorkOutLift
//
//  Created by Apple on 2019/5/3.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

extension Double {
    
    // swiftlint:disable identifier_name
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
}
