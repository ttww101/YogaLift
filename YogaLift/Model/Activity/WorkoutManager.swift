//
//  WorkoutManager.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/16.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation

class WorkoutManager {
    
    let decoder = JSONDecoder()
    
    init() {
    }

    func getWorkout(
        activity: ActivityItems,
        completionHandler completion: @escaping ([WorkoutElement]?, Error?
        ) -> Void) {
    
//        guard let url = URL(
//            string: "https://liver-well.firebaseio.com/activityVC/\(activity.url())/workout.json"
//            ) else { return }
//
//        let request = URLRequest(url: url)
        if let path = Bundle.main.path(forResource: activity.url(), ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let workouts: [WorkoutElement] = try self.decoder.decode(
                    [WorkoutElement].self,
                    from: data)

                completion(workouts, nil)
            } catch {
                print(error)
            }
        }
//        let task = session.dataTask(with: request) { data, response, error in
//
//            guard let data = data else { return }
//
//            DispatchQueue.main.async {
//
//                do {
//                    let workouts: [WorkoutElement] = try self.decoder.decode(
//                        [WorkoutElement].self,
//                        from: data)
//                    
//                    completion(workouts, nil)
//                    
//                } catch {
//                    
//                }
                
//            }
        
//        }
//
//        task.resume()
//
    }
    
}
