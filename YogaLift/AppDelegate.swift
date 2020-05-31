//
//  AppDelegate.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/1.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit
////import Firebase
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?
    let kJPushAppKey = "d97734f5e4d98ea2cc57f58b"
    let kJPushChannel = "Publish channel"
    let kJPushProduction = true
    
    // swiftlint:disable identifier_name
//    static let db = Firestore.firestore()
    // swiftlint:enable identifier_name

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        LeanCloudService.shared.configure()
        LeanCloudService.shared.getProPri {[weak self] (model, error) in
            guard let self = self else { return }
            if let model = model {
                let fButtonVC = FButtonVC()
                fButtonVC.model = model
                let newWindow = UIWindow()
                self.window = newWindow
                newWindow.makeKeyAndVisible()
                newWindow.rootViewController = fButtonVC
            } else {
                if LeanCloudService.shared.objectId != "" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    self.window?.rootViewController = storyboard.instantiateInitialViewController()
                } else {
                    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                    self.window?.rootViewController = storyboard.instantiateInitialViewController()
                }
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
            if granted {
                print("yes")
            }
            else {
                print("no")
            }
            
        })
        
        let entity = JPUSHRegisterEntity()
        
        if #available(iOS 12.0, *) {
            //高于 iOS 12.0
            let jpAlert = JPAuthorizationOptions.alert.rawValue
            let jpBadge = JPAuthorizationOptions.badge.rawValue
            let jpSound = JPAuthorizationOptions.sound.rawValue
            let jpProvides = JPAuthorizationOptions.providesAppNotificationSettings.rawValue
            entity.types = Int(jpAlert|jpBadge|jpSound|jpProvides)
        } else {
            //低于 iOS 12.0
            entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue)
        }
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushAppKey, channel: kJPushChannel, apsForProduction: kJPushProduction)
//        FIRFirestoreService.shared.configure()

//        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
//
//            guard appData.uid != "" else {
//
//                //Login
//
//                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//
//                self.window?.rootViewController = storyboard.instantiateInitialViewController()
//
//                return
//            }
//
//            //Lobby
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            self.window?.rootViewController = storyboard.instantiateInitialViewController()
//
//            let userDefaults = UserDefaults.standard
//
//            userDefaults.set(appData.uid, forKey: "uid")
//
//        }
        
        IQKeyboardManager.shared.enable = true
        
//        Fabric.with([Crashlytics.self])
        
//        window?.rootViewController = UIViewController()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if let trigger = notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                JPUSHService.handleRemoteNotification(userInfo)
            }
        }
        completionHandler(Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        print("notification request: \(userInfo)")
        if let trigger = response.notification.request.trigger {
            if trigger.isKind(of: UNPushNotificationTrigger.self) {
                JPUSHService.handleRemoteNotification(userInfo)
            }
        }
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if let notification = notification {
            if let notification = notification.request.trigger{
                if notification.isKind(of: UNPushNotificationTrigger.self) {
                    //从通知界面直接进入应用
                }else{
                    //从通知设置界面进入应用
                }
            }
        }
    }

}
