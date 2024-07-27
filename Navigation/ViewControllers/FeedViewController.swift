//
//  FeedViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit

class FeedViewController: UIViewController {
    
    private lazy var btnToPost: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перейти", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        return button
    }()

    private let postInMemorySample = Post("Тест для примера")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Лента"
        
        view.addSubview(btnToPost)
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            btnToPost.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40.0),
            btnToPost.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40.0),
            btnToPost.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            btnToPost.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        
        btnToPost.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        let postViewController = PostViewController(post: postInMemorySample)
        
        navigationController?.pushViewController(postViewController, animated: true)
    }

}
