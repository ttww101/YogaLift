//
//  LeanCloudService.swift
//   WorkOutLift
//
//  Created by Apple on 7/3/19.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import Foundation
import LeanCloud
import Alamofire

class LeanCloudService {
    static let shared = LeanCloudService()
    let userDefault = UserDefaults.standard
    var objectId = ""
    
    private init() {
        if let objectId = self.userDefault.string(forKey: "objectId") {
            self.objectId = objectId
        }
    }
    
    private func saveObjectId() {
        self.userDefault.set(objectId, forKey: "objectId")
        self.userDefault.synchronize()
    }
    func clearObjectId() {
        objectId = ""
        self.userDefault.removeObject(forKey: "objectId")
        self.userDefault.synchronize()
    }
    
    func configure() {
        do {
            try LCApplication.default.set(
                id:  "6xscV54opvclq2w6aBfYOIkS-MdYXbMMI",
                key: "RsH5TDYqyRE5Lze2zrrRX2Tp"
            )
        } catch {
            print("")
        }
    }
    
    func getProPri(completion: @escaping ([String:String]?, Error?) -> Void) {
        let query = LCQuery(className: "purpose")
        let _ = query.getFirst { (result) in
            switch result {
            case .success(object: let object):
                // get value by string key
                guard let flag = object.get("flag")?.stringValue else {
                    completion(nil, nil)
                    return
                }
                guard let type = object.get("type")?.stringValue else {
                    completion(nil, nil)
                    return
                }
                let model = ["flag": flag,
                             "type": type]
                completion(model, nil)
            case .failure(error: let error):
                completion(nil, nil)
            }
        }
    }
    
    func createUser(username: String, account: String, password: String, nowWeight: Double, goalWeight: Double, completion: @escaping (Bool, String, Error?) -> Void) {
        let query = LCQuery(className: "UserInfo")
        query.whereKey("account", .equalTo(account))
        if query.getFirst().object != nil {
            completion(false, "帐号重复", nil)
        } else {
            do {
                let todo = LCObject(className: "UserInfo")
                try todo.set("account", value: account)
                try todo.set("password", value: password)
                try todo.set("username", value: username)
                try todo.set("nowWeight", value: nowWeight)
                try todo.set("goalWeight", value: goalWeight)
                let _ = todo.save {[weak self](result) in
                    switch result {
                    case .success:
                        self?.objectId = todo.objectId!.stringValue!
                        self?.saveObjectId()
                        completion(true, "注册成功", nil)
                    case .failure(let error):
                        completion(false, "帐号重复", error)
                    }
                }
            } catch {
                // handle error
            }
        }
    }
    
    func login(_ account: String, _ password: String, completion: @escaping (Bool, String) -> Void) {
        let query = LCQuery(className: "UserInfo")
        query.whereKey("account", .equalTo(account))
        query.whereKey("password", .equalTo(password))
        if let object = query.getFirst().object {
            self.objectId = object.objectId!.stringValue!
            self.saveObjectId()
            completion(true, "登入成功")
        } else {
            completion(false, "帐号密码错误")
        }
    }
    
    func saveActivity(_ type: String, _ title: String, _ time: Int, completion: @escaping (Bool, Error?) -> Void) {
        do {
            let todo = LCObject(className: "Activity")
            try todo.set("userid", value: objectId)
            try todo.set("type", value: type)
            try todo.set("title", value: title)
            try todo.set("time", value: time)
            let _ = todo.save {[weak self](result) in
                switch result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error)
                }
            }
        } catch {
            // handle error
        }
    }
    
    func getUserName(completion: @escaping (String, Error?) -> Void) {
        do {
            let query = LCQuery(className: "UserInfo")
            let _ = query.get(objectId) { (result) in
                switch result {
                case .success(object: let object):
                    // get value by string key
                    let name = object.get("username")?.stringValue
                    completion(name!, nil)
                case .failure(error: let error):
                    completion("", error)
                }
            }
        } catch {
            // handle error
        }
    }
    
}
