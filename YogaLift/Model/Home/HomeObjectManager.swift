//
//  HomeObjectManager.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

class HomeObjectManager {
    
    let decoder = JSONDecoder()
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        
        self.init(configuration: .default)
    }
    
    func getHomeObject(
        homeStatus: HomeStatus,
        completionHandler completion: @escaping (HomeObject?, Error?
        ) -> Void) {
        
        if let path = Bundle.main.path(forResource: "homestatus\(homeStatus.url())", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let homeObject: HomeObject = try self.decoder.decode(
                    HomeObject.self,
                    from: data)
                completion(homeObject, nil)
            } catch {
                completion(nil, error)
            }
        }
        
//
//        guard let url = URL(
//            string: "https://liver-well.firebaseio.com/homeVC/\(homeStatus.url()).json"
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
//                    let homeObject: HomeObject = try self.decoder.decode(
//                        HomeObject.self,
//                        from: data)
//                    completion(homeObject, nil)
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
