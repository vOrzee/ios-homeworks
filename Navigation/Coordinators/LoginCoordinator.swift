//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import UIKit
import StorageService

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LogInViewController()
        loginViewController.coordinator = self
        loginViewController.setDelegate(MyLoginFactory().makeLoginInspector())
        navigationController.pushViewController(loginViewController, animated: false)
        
        loginViewController.tabBarItem = UITabBarItem(
            title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1
        )
    }
    
    func showProfileAfterLogin(user: User) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.startByAuthorization(with: user)
    }
}
