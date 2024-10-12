//
//  InfoViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    var coordinator: InfoCoordinator?
    
    private lazy var actionButton: CustomButton = {
        let button = CustomButton(
            title: "Вызвать предупреждение", titleColor: .white, backgroundColor: .orange,
            action: { [weak self] in
                guard let self else { return }
                self.coordinator?.showAlert()
            }
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(actionButton)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40.0),
            actionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40.0),
            actionButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
}
