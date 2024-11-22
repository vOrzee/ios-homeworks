//
//  MapCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 19.11.2024.
//

import UIKit

class MapCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapViewController = MapViewController()
        mapViewController.coordinator = self
        navigationController.pushViewController(mapViewController, animated: false)
        
        mapViewController.tabBarItem = UITabBarItem(
            title: "Карта", image: UIImage(systemName: "map"), tag: 0
        )
    }
}
