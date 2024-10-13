//
//  PostCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 13.10.2024.
//

import UIKit
import StorageService

class PostCoordinator: Coordinator {
    var navigationController: UINavigationController
    var post: Post

    init(navigationController: UINavigationController, post: Post) {
        self.navigationController = navigationController
        self.post = post
    }

    func start() {
        let postViewController = PostViewController(post: post)
        postViewController.coordinator = self
        navigationController.pushViewController(postViewController, animated: true)
    }

    func showInfo() {
        let infoCoordinator = InfoCoordinator(navigationController: navigationController)
        infoCoordinator.start()
    }
}
