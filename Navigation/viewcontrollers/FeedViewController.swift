//
//  FeedViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 09.12.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    private lazy var goToPostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        
        return button
    }()
    
    private let postInMemory: Post = Post(title: "Пост №734")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Стена"
        view.backgroundColor = .systemGray5
        view.addSubview(goToPostButton)
        
        goToPostButton.addTarget(self, action: #selector(goToPost), for: .touchUpInside)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            goToPostButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            goToPostButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            goToPostButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            goToPostButton.heightAnchor.constraint(equalToConstant: 64.0),
        ])
    }
    
    @objc func goToPost(_ sender: UIButton) {
        let postViewController = PostViewController()
        postViewController.post = postInMemory
        navigationController?.pushViewController(postViewController, animated: true)
    }

}
