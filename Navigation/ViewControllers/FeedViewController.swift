//
//  FeedViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    private let postInMemorySample = PostRepositoryInMemory.make()[0]
    
    private var feedModel = FeedModel(secretWord: "гладиолус")
    
    private lazy var entryField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "Проверить", titleColor: .white, backgroundColor: .orange,
            action: { [weak self] in
                guard let self = self else {return}
                self.check()
            }
        )
        return button
    }()
    
    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.text = "ОТВЕТ"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Лента"
        
        view.addSubview(stackView)
        view.addSubview(entryField)
        view.addSubview(checkGuessButton)
        view.addSubview(answerLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            entryField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            entryField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8.0),
            entryField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24.0),
            entryField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24.0),
            checkGuessButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            checkGuessButton.topAnchor.constraint(equalTo: entryField.bottomAnchor, constant: 8.0),
            checkGuessButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24.0),
            checkGuessButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24.0),
            answerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            answerLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 8.0),
            answerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24.0),
            answerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24.0),
        ])
    }
    
    private func check() {
        let result = feedModel.check(word: entryField.text ?? "")
        answerLabel.text = entryField.text?.uppercased()
        if result {
            answerLabel.textColor = .green
        } else {
            answerLabel.textColor = .red
        }
    }
}
