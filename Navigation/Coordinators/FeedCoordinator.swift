//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import UIKit
import StorageService

class FeedCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let feedViewController = FeedViewController(
            feedViewOutput: FeedViewModel(),
            postViewOutput: PostViewModel.shared
        )
        feedViewController.coordinator = self
        navigationController.pushViewController(feedViewController, animated: false)
        
        feedViewController.tabBarItem = UITabBarItem(
            title: "Лента", image: UIImage(systemName: "list.bullet"), tag: 0
        )
    }
    
    func showPostDetails(post: Post) {
        let postCoordinator = PostCoordinator(navigationController: navigationController, post: post)
        postCoordinator.start()
    }
}
