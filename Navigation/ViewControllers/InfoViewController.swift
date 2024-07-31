//
//  InfoViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вызвать предупреждение", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    
    @objc func buttonPressed() {
        let alertController = UIAlertController(title: "Заголовок предупреждения", message: "Текст предупреждения", preferredStyle: .alert)
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
        self.present(alertController, animated: true)
    }
    
}
