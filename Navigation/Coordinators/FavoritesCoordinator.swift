//
//  FavoritesCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 17.10.2024.
//

import UIKit
import StorageService

class FavoritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let favoritesViewController = FavoriteViewController()
        favoritesViewController.coordinator = self
        navigationController.pushViewController(favoritesViewController, animated: false)
        
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Сохранённое", image: UIImage(systemName: "externaldrive"), tag: 1
        )
    }
}
