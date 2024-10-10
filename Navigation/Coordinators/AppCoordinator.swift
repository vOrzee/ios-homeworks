//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    var tabBarController: UITabBarController
    var navigationController: UINavigationController
    var feedCoordinator: FeedCoordinator
    var profileCoordinator: ProfileCoordinator
    var loginCoordinator: LoginCoordinator
    
    init() {
        self.tabBarController = UITabBarController()
        self.navigationController = UINavigationController()
        self.feedCoordinator = FeedCoordinator(navigationController: UINavigationController())
        self.profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        self.loginCoordinator = LoginCoordinator(navigationController: UINavigationController())
    }
    
    func start() {
        feedCoordinator.start()
        profileCoordinator.start()
        loginCoordinator.start()
        
        tabBarController.viewControllers = [
            feedCoordinator.navigationController,
            loginCoordinator.navigationController
        ]
        
        tabBarController.selectedIndex = 1
    }
}

