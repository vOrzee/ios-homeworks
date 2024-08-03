//
//  FeedViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit

class FeedViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.alignment = .fill
        stackView.addArrangedSubview(topButton)
        stackView.addArrangedSubview(bottomButton)
        return stackView
    }()
    
    private lazy var topButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Верхняя кнопка", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.addTarget(self, action: #selector(buttonTopPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Нижняя кнопка", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        button.addTarget(self, action: #selector(buttonBottomPressed), for: .touchUpInside)
        return button
    }()

    private let postInMemorySample = posts[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Лента"
        
        view.addSubview(stackView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
    
    @objc func buttonTopPressed() {
        let postViewController = PostViewController(post: postInMemorySample)
        
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    @objc func buttonBottomPressed() {
        let postViewController = PostViewController(post: postInMemorySample)
        
        navigationController?.pushViewController(postViewController, animated: true)
    }

}
