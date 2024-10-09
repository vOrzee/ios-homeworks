//
//  FeedViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit
import StorageService

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
    
    private lazy var topButton: CustomButton = {
        let button = CustomButton(
            title: "Верхняя кнопка", titleColor: .systemTeal, backgroundColor: .blue,
            action: { [weak self] in
                guard let self = self else {return}
                let postViewController = PostViewController(post: postInMemorySample)
                navigationController?.pushViewController(postViewController, animated: true)
            }
        )
        return button
    }()
    
    private lazy var bottomButton: CustomButton = {
        let button = CustomButton(
            title: "Нижняя кнопка", titleColor: .systemTeal, backgroundColor: .red,
            action: { [weak self] in
                guard let self = self else {return}
                let postViewController = PostViewController(post: postInMemorySample)
                navigationController?.pushViewController(postViewController, animated: true)
            }
        )
        return button
    }()

    private let postInMemorySample = PostRepositoryInMemory.make()[0]
    
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
}
