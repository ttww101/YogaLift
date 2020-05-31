//
//  HomeManager.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019 SSMNT. All rights reserved.
//
import Foundation
////import Firebase
import MBCircularProgressBar
import LeanCloud

class HomeProvider {
    
    let now = Date()
    
    var monSum = 0
    var tueSum = 0
    var wedSum = 0
    var thuSum = 0
    var friSum = 0
    var satSum = 0
    var sunSum = 0
    
    var dailyValue: [Int] {
        
        return [monSum, tueSum, wedSum, thuSum, friSum, satSum, sunSum]
        
    }
    
    var todayTrainTime: Int = 0
    
    var todayYinYogaTime: Int = 0
    
    func getThisWeekProgress(today: Date, completion: @escaping (Result<[Int], Error>) -> Void) {
        
        let userDefaults = UserDefaults.standard
        
        guard LeanCloudService.shared.objectId != "" else { return }
        
        let today = today
        
        let cql = "select * from Activity where userid = '\(LeanCloudService.shared.objectId)' and createdAt > date('\(today.dayOf(.monday).getLCTime())') order by createdAt asc"
        
        _ = LCCQLClient.execute(cql) { result in
            switch result {
            case .success(let result):
                var workouts: [WorkOut?] = []
                let todos = result.objects
                for iii in 0..<todos.count {
                    let time = todos[iii]["time"]?.intValue
                    let type = todos[iii]["type"]?.stringValue
                    let date = todos[iii]["createdAt"]?.dateValue
                    let item = WorkOut(workOutTime: time!, activityType: type!, createdTime: date!)
                    
                    workouts.append(item)
                }
                let nonnilWorkouts = workouts.compactMap({ $0 })
                
                for item in nonnilWorkouts {
                    self.sortBy(day: item.createdTime, workoutType: item.activityType, workoutTime: item.workOutTime)
                }
                completion(Result.success(self.dailyValue))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
        
//        let workoutRef = AppDelegate.db.collection("users").document(uid).collection("workout")
//        
//        workoutRef
//            .whereField("created_time", isGreaterThan: today.dayOf(.monday))
//            .order(by: "created_time", descending: false)
//            .getDocuments { (snapshot, error) in
//                
//                if let error = error {
//                
//                    print("Error getting documents: \(error)")
//                
//                } else {
//                    
//                    var workouts: [WorkOut?] = []
//                    
//                    for document in snapshot!.documents {
//                        
//                        let createdTime = document.get("created_time") as? Timestamp
//                        
//                        var data = document.data()
//                        
//                        data.removeValue(forKey: "created_time")
//                        
//                        var item = try? document.decode(as: WorkOut.self, data: data)
//                        
//                        item?.createdTime = createdTime
//                        
//                        workouts.append(item)
//
//                    }
//                    
//                    let nonnilWorkouts = workouts.compactMap({ $0 })
//                    
//                    for item in nonnilWorkouts {
//                        
//                        if let time = item.createdTime?.dateValue() {
//                            
//                            self.sortBy(day: time, workoutType: item.activityType, workoutTime: item.workOutTime)
//                        }
//                    }
//                    
//                    completion(Result.success(self.dailyValue))
//                }
//        }
    }
    
    private func sortBy(day date: Date, workoutType: String, workoutTime: Int) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.string(from: date)
        
        let today = Date()
        
        if convertedDate == dateFormatter.string(from: today) && workoutType == "train" {
            
            self.todayTrainTime += workoutTime
            
        } else if convertedDate == dateFormatter.string(from: today) && workoutType == "yinyoga" {
            
            self.todayYinYogaTime += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.monday)) {
            self.monSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.tuesday)) {
            self.tueSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.wednesday)) {
            self.wedSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.thursday)) {
            self.thuSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.friday)) {
            self.friSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.saturday)) {
            self.satSum += workoutTime
        }
        
        if convertedDate == dateFormatter.string(from: today.dayOf(.sunday)) {
            self.sunSum += workoutTime
        }
        
    }
    
    func reset() {
        
        todayTrainTime = 0
        todayYinYogaTime = 0
        
        monSum = 0
        tueSum = 0
        wedSum = 0
        thuSum = 0
        friSum = 0
        satSum = 0
        sunSum = 0
    }
    
    func determineStatusAt(
        time: Date = Date(),
        workStartHour: Int,
        workEndHour: Int
        ) -> (status: HomeStatus, description: String) {
        
        let sunday = time.dayOf(.sunday)
        let saturday = time.dayOf(.saturday)
        
        let workStart = time.dateAt(hours: workStartHour, minutes: 0)
        let workEnd = time.dateAt(hours: workEndHour, minutes: 0)
        let sleepStart = time.dateAt(hours: 21, minutes: 30)
        let sleepEnd = time.dateAt(hours: 5, minutes: 0)
        let nowHour = Calendar.current.component(.hour, from: time)
        
        if time >= saturday && time <= Calendar.current.date(byAdding: .day, value: 1, to: sunday)! {
            
            // weekend
            if time >= sleepEnd && time <= sleepStart {
                
                return (.resting, "休息日好好放松，起身动一动！")
                
            } else {
                
                return (.beforeSleep, "休息日好好放松，起身动一动！")
            }
            
        } else {
            
            // workday
            let fromRestHour = workEndHour - nowHour
            
            if time >= workStart && time <= workEnd {
                
                return (.working, "离休息时间还有 \(fromRestHour) 小时")
                
            } else if time >= workEnd && time <= sleepStart {
                
                return (.resting, "离工作时间还有 \((24 - nowHour) + workStartHour) 小时")
                
            } else if time >= sleepEnd && time <= workStart {
                
                return (.resting, "离工作时间还有 \(workStartHour - nowHour) 小时")
                
            } else {
                
                if nowHour > workEndHour {
                    
                    return (.beforeSleep, "离工作时间还有 \((24 - nowHour) + workStartHour) 小时")
                    
                } else if nowHour < workStartHour {
                    
                    return (.beforeSleep, "离工作时间还有 \(workStartHour - nowHour) 小时")
                    
                } else {
                    
                    return (.beforeSleep, "")
                }
            }
        }
    }

}
