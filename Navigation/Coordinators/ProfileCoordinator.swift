//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import UIKit
import StorageService

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var user: User?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startByAuthorization(with user: User) {
        self.user = user
        start()
    }
    
    func start() {
        guard let user = user else {return}
        let profileViewController = ProfileViewController(user: user, postViewOutput: PostViewModel.shared)
        profileViewController.coordinator = self
        navigationController.pushViewController(profileViewController, animated: false)
    }
    
    func showPhotos(photos: [UIImage?]) {
        let photosViewController = PhotosViewController(photos: photos)
        navigationController.pushViewController(photosViewController, animated: true)
    }
}
