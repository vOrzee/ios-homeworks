//
//  InfoViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 09.12.2023.
//

import UIKit

class InfoViewController: UIViewController {

    private lazy var alertButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("ТРЕВОГА!!!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(alertButton)
        alertButton.addTarget(self, action: #selector(pushAlert), for: .touchUpInside)
        
        // Расположение:
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            alertButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            alertButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            alertButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            alertButton.heightAnchor.constraint(equalToConstant: 48.0),
        ])
    }
    

    @objc func pushAlert(_ sender: UIButton) {
        let alertController = UIAlertController()
        alertController.title = "Сообщение"
        alertController.message = "Тревожная кнопка нажата"
        let actionOne = UIAlertAction(title: "Первое действие", style: .default) { _ in
            print("Выбрано первое действие")
        }
        let actionTwo = UIAlertAction(title: "Второе действие", style: .default) { _ in
            print("Выбрано второе действие")
        }
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        present(alertController, animated: true)
    }
}
