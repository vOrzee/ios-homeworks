//
//  Coordinator.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
