//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import UIKit
import FirebaseAuth
import StorageService

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    var loginInspector: LoginInspector? // Пришлось добавить сильную ссылку тут
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LogInViewController()
        loginViewController.coordinator = self
        loginInspector = MyLoginFactory().makeLoginInspector()
        guard let loginInspector = loginInspector else {return}
        loginViewController.setDelegate(loginInspector)
        navigationController.pushViewController(loginViewController, animated: false)
        
        loginViewController.tabBarItem = UITabBarItem(
            title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1
        )
    }
    
    func showProfileAfterLogin(user: StorageService.User) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.startByAuthorization(with: user)
    }
    
    func showAuthAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController.present(alert, animated: true, completion: nil)
    }
}
