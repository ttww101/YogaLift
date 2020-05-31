//
//  Int+Extension.swift
//   WorkOutLift
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}
