//
//  WorkoutSetManager.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

class WorkoutElementManager {
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getWorkoutElement(
        id: String,
        completionHandler completion: @escaping (WorkoutElement?, Error?
        ) -> Void) {
        if let path = Bundle.main.path(forResource: id, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let workoutElement: WorkoutElement = try self.decoder.decode(
                    WorkoutElement.self,
                    from: data)
                print(workoutElement)

                completion(workoutElement, nil)
            } catch {
                
            }
        }
//        guard let url = URL(
//            string: "https://liver-well.firebaseio.com/activityVC/\(id).json"
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
//                    let workoutElement: WorkoutElement = try self.decoder.decode(
//                        WorkoutElement.self,
//                        from: data)
//                    print(workoutElement)
//
//                    completion(workoutElement, nil)
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
