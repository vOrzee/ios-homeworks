//
//  InfoCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 13.10.2024.
//

import UIKit

class InfoCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let infoViewController = InfoViewController()
        infoViewController.modalTransitionStyle = .flipHorizontal
        infoViewController.modalPresentationStyle = .pageSheet
        infoViewController.coordinator = self
        navigationController.pushViewController(infoViewController, animated: true)
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "Заголовок предупреждения",
            message: "Текст предупреждения",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "Первое действие",
                style: .default,
                handler: { _ in
                    print("Выбрано первое действие")
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: "Второе действие",
                style: .default,
                handler: { _ in
                    print("Выбрано второе действие")
                }
            )
        )
        
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
