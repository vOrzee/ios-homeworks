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
            title: NSLocalizedString("Alert Header", comment: ""),
            message: NSLocalizedString("Warning text", comment: ""),
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: NSLocalizedString("First Act", comment: ""),
                style: .default,
                handler: { _ in
                    print(NSLocalizedString("First action selected", comment: ""))
                }
            )
        )
        alertController.addAction(
            UIAlertAction(
                title: NSLocalizedString("Second Act", comment: ""),
                style: .default,
                handler: { _ in
                    print(NSLocalizedString("Second action selected", comment: ""))
                }
            )
        )
        
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
