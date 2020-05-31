//
//  StatusManager.swift
//   WorkOutLift
//
//  Created by Jo Yun Hsu on 2019/5/13.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation
//import Firebase
import LeanCloud

class StatusProvider {
    
    // swiftlint:disable identifier_name
    var TrainASum = 0
    var TrainBSum = 0
    var TrainCSum = 0
    var TrainDSum = 0
    var TrainESum = 0
    var YinYogaASum = 0
    var YinYogaBSum = 0
    var YinYogaCSum = 0
    var YinYogaDSum = 0
    var YinYogaESum = 0
    
    var monSum = [0, 0] // [train, yinyoga]
    var tueSum = [0, 0]
    var wedSum = [0, 0]
    var thuSum = [0, 0]
    var friSum = [0, 0]
    var satSum = [0, 0]
    var sunSum = [0, 0]
    var weekSum: [[Int]] {
        return [monSum, tueSum, wedSum, thuSum, friSum, satSum, sunSum]
    }
    
    var yinyogaTimeSum = 0
    var trainTimeSum = 0
    var workoutDataArray = [WorkoutData]()

    func getWeeklyWorkout(weeksBefore: Int, completion: @escaping (Result<[WorkoutData], Error>) -> Void) {
        
        reset()

        guard LeanCloudService.shared.objectId != "" else { return }
        
        let today = Date()

        guard let referenceDay = Calendar.current.date(
            byAdding: .day,
            value: 0 + 7 * weeksBefore,
            to: today) else { return }

        let monday = referenceDay.dayOf(.monday)

        let sunday = referenceDay.dayOf(.sunday)
        
        let obid = LeanCloudService.shared.objectId
        let lessDate = Calendar.current.date(byAdding: .day, value: 1, to: sunday)!.getLCTime()
        let greaterDate = monday.getLCTime()
        
        let cql = "select * from Activity where userid = '\(obid)' and createdAt < date('\(lessDate)') and createdAt > date('\(greaterDate)') order by created asc"
        
        _ = LCCQLClient.execute(cql) { result in
            switch result {
            case .success(let result):
                let todos = result.objects
                for iii in 0..<todos.count {
                    let time = todos[iii]["time"]?.intValue
                    let type = todos[iii]["type"]?.stringValue
                    let title = todos[iii]["title"]?.stringValue
                    let date = todos[iii]["createdAt"]?.dateValue
                    let item = WorkoutData(timestampToDate: date, workoutTime: time!, title: title!, activityType: type!)
                    
                    self.workoutDataArray.append(item)
                    
                }
                for _ in self.workoutDataArray {
                    
                    self.sortByTitle()
                    
                    self.sortByType()
                    
                    self.sortByDayAndType(weeksBefore: weeksBefore)
                    
                }
                
                completion(Result.success(self.workoutDataArray))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
//        
//        let workoutRef = AppDelegate.db.collection("users").document(user.uid).collection("workout")
//        
//        let today = Date()
//        
//        guard let referenceDay = Calendar.current.date(
//            byAdding: .day,
//            value: 0 + 7 * weeksBefore,
//            to: today) else { return }
//        
//        let monday = referenceDay.dayOf(.monday)
//        
//        let sunday = referenceDay.dayOf(.sunday)
//        
//        workoutRef
//            .whereField("created_time", isLessThan: Calendar.current.date(byAdding: .day, value: 1, to: sunday)!)
//            .whereField("created_time", isGreaterThan: monday)
//            .order(by: "created_time", descending: false) // 由舊到新
//            .getDocuments { [weak self] (snapshot, error) in
//                
//                if let error = error {
//                    print("Error getting document: \(error)")
//                } else {
//                    for document in snapshot!.documents {
//                        
//                        guard let createdTime = document.get("created_time") as? Timestamp else { return }
//                        
//                        var json = document.data()
//                        
//                        json["created_time"] = nil
//                        
//                        var item = try? document.decode(as: WorkoutData.self, data: json)
//                        
//                        item?.timestampToDate = createdTime.dateValue()
//                        
//                        self?.workoutDataArray.append(item!)
//                        
//                    }
//                    
//                    for _ in self!.workoutDataArray {
//                            
//                        self?.sortByTitle()
//                        
//                        self?.sortByType()
//                        
//                        self?.sortByDayAndType(weeksBefore: weeksBefore)
//                    
//                    }
//                    
//                    completion(Result.success(self!.workoutDataArray))
//                }
//                
//        }
        
    }
    
    private func sortByTitle() {
        
        self.TrainASum = getWorkoutSumBy(title: TrainItem.TrainA.title)
        
        self.TrainBSum = getWorkoutSumBy(title: TrainItem.TrainB.title)
        
        self.TrainCSum = getWorkoutSumBy(title: TrainItem.TrainC.title)
        
        self.TrainDSum = getWorkoutSumBy(title: TrainItem.TrainD.title)
        
        self.TrainESum = getWorkoutSumBy(title: TrainItem.TrainE.title)
        
        self.YinYogaASum = getWorkoutSumBy(title: YinYogaItem.YinYogaA.title)
        
        self.YinYogaBSum = getWorkoutSumBy(title: YinYogaItem.YinYogaB.title)
        
        self.YinYogaCSum = getWorkoutSumBy(title: YinYogaItem.YinYogaC.title)
        
        self.YinYogaDSum = getWorkoutSumBy(title: YinYogaItem.YinYogaD.title)
        
        self.YinYogaESum = getWorkoutSumBy(title: YinYogaItem.YinYogaE.title)
    }
    
    private func sortByType() {
        
        self.trainTimeSum = getWorkoutSumBy(type: ActivityType.train.rawValue)
        
        self.yinyogaTimeSum = getWorkoutSumBy(type: ActivityType.yinyoga.rawValue)
        
    }
    
    private func sortByDayAndType(weeksBefore: Int) {
        
        let today = Date()
        
        guard let referenceDay = Calendar.current.date(
            byAdding: .day,
            value: 0 + 7 * weeksBefore,
            to: today) else { return }
        
        self.monSum = filterByDayAndType(day: referenceDay.dayOf(.monday))
        
        self.tueSum = filterByDayAndType(day: referenceDay.dayOf(.tuesday))
        
        self.wedSum = filterByDayAndType(day: referenceDay.dayOf(.wednesday))
        
        self.thuSum = filterByDayAndType(day: referenceDay.dayOf(.thursday))
        
        self.friSum = filterByDayAndType(day: referenceDay.dayOf(.friday))
        
        self.satSum = filterByDayAndType(day: referenceDay.dayOf(.saturday))
        
        self.sunSum = filterByDayAndType(day: referenceDay.dayOf(.sunday))
        
    }
    
    private func filterByDayAndType(day: Date) -> [Int] {
        
        let convertedDate = DateFormatter.yearMonthDay(date: day)
        
        let dayTrain = workoutDataArray.filter({
            
            $0.convertedDate == convertedDate && $0.activityType == ActivityType.train.rawValue
            
        })
        
        let dayYinYoga = workoutDataArray.filter({
            
            $0.convertedDate == convertedDate && $0.activityType == ActivityType.yinyoga.rawValue
            
        })
        
        return [timeSumOf(array: dayTrain), timeSumOf(array: dayYinYoga)]
        
    }
    
    private func getWorkoutSumBy(type: String) -> Int {
        
        let array = self.workoutDataArray.filter({
            
            $0.activityType == type
            
        })
        
        return timeSumOf(array: array)
    }
    
    private func getWorkoutSumBy(title: String) -> Int {
        
        let array = self.workoutDataArray.filter({
            
            $0.title == title
            
        })
        
        return timeSumOf(array: array)
    }
    
    func percentageOf(entry sum: Int) -> Int {
        
        let totalSum = yinyogaTimeSum + trainTimeSum
        
        let percentage = lround(Double(sum * 100 / totalSum))
        
        return percentage
        
    }
    
    private func timeSumOf(array: [WorkoutData]) -> Int {
        
        var timeArray = [Int]()
        
        for i in 0..<array.count {
            
            timeArray.append(array[i].workoutTime)
            
        }
        
        let timeSum = timeArray.reduce(0, +)
        
        return timeSum
        
    }
    
    func reset() {
        
        workoutDataArray = [WorkoutData]()
        
        monSum = [0, 0]
        tueSum = [0, 0]
        wedSum = [0, 0]
        thuSum = [0, 0]
        friSum = [0, 0]
        satSum = [0, 0]
        sunSum = [0, 0]
    }
    
}
