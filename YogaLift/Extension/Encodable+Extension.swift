//
//  Encodable+Extension.swift
//   WorkOutLift
//
//  Created by Apple on 2019/7/5.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

enum LWError: Error {
    case encodingError
}

extension Encodable {
    
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {
        
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw LWError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        
        return json
    }
    
}
