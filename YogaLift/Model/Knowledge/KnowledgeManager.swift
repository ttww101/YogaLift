//
//  KnowledgeManager.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/17.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

class KnowledgeManager {
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getKnowledge(
        completionHandler completion: @escaping ([Knowledge]?, Error?
        ) -> Void) {
        
        if let path = Bundle.main.path(forResource: "knowledge", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let knowledges: [Knowledge] = try self.decoder.decode(
                    [Knowledge].self,
                    from: data)
                
                completion(knowledges, nil)
            } catch {
                completion(nil, error)
            }
        }
        
//        guard let url = URL(
//            string: "https://liver-well.firebaseio.com/knowledgeVC.json"
//            ) else { return }
//        
//        let request = URLRequest(url: url)
//        
//        let task = session.dataTask(with: request) { data, response, error in
//            
//            guard let data = data else { return }
//            
//            DispatchQueue.main.async {
//                
//                do {
//                    let knowledges: [Knowledge] = try self.decoder.decode(
//                        [Knowledge].self,
//                        from: data)
//                    
//                    completion(knowledges, nil)
//                    
//                } catch {
//                    
//                }
//                
//            }
//            
//        }
//        
//        task.resume()
        
    }
    
}
