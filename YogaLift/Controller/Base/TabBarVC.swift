//
//  TabBarVC.swift
//   WorkOutLift
//
//  Created by Apple on 2019/4/3.
//  Copyright © 2019 SSMNT. All rights reserved.
//

import UIKit

private enum TabVC {

    case home

    case activity

    case knowledge

    case profile

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .home: controller = UIStoryboard.home.instantiateInitialViewController()!

//        case .home: controller = UIViewController()
            
        case .activity: controller = UIStoryboard.activity.instantiateInitialViewController()!

//        case .activity: controller = UIViewController()
            
        case .knowledge: controller = UIStoryboard.knowledge.instantiateInitialViewController()!
            
//        case .knowledge: controller = UIViewController()

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
            
//        case .profile: controller = UIViewController()
        }

        controller.tabBarItem = tabBarItem()

        return controller

    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .home: return UITabBarItem(
            title: "首页",
            image: UIImage.asset(.Icon_24px_Home_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Home_Selected)
            )

        case .activity: return UITabBarItem(
            title: "动一动",
            image: UIImage.asset(.Icon_24px_Workout_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Workout_Selected)
            )

        case .knowledge: return UITabBarItem(
            title: "肝好知识",
            image: UIImage.asset(.Icon_24px_Knowledge_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Knowledge_Selected)
            )

        case .profile: return UITabBarItem(
            title: "我的",
            image: UIImage.asset(.Icon_24px_Profile_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Profile_Selected)
            )
        }

    }

}

class TabBarVC: UITabBarController {

    private let tabs: [TabVC] = [.home, .activity, .knowledge, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })
    }

}
