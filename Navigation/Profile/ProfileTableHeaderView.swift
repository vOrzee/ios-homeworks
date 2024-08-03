//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Роман Лешин on 27.07.2024.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private var statusText: String = "Waiting for something..."
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        
        if let image = UIImage(named: "HipsterCat") {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        
        return imageView
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .black
        label.text = "Hipster Cat"
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray
        label.text = statusText
        return label
    }()
    
    lazy var statusTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(
            self,
            action: #selector(statusTextChanged),
            for: .editingChanged
        )
        textField.placeholder = statusText
        textField.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        textField.textColor = .black
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 12.0
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }()
    
    lazy var setStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Set status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 4.0
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatarImageView)
        self.addSubview(fullNameLabel)
        self.addSubview(statusLabel)
        self.addSubview(statusTextField)
        self.addSubview(setStatusButton)
        self.backgroundColor = .lightGray
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.circleCrop()
    }
    
    override var intrinsicContentSize: CGSize {
//        let height = 16.0 // отступ сверху
//                    + avatarImageView.bounds.height // высота аватарки
//                    - 18.0 // смещение статуса
//                    + 12.0 // отступ до смены статуса
//                    + statusTextField.bounds.height // высота поля ввода
//                    + 16.0 // отступ до кнопки
//                    + setStatusButton.bounds.height // высота кнопки
//                    + 16.0 // отступ после кнопки
        return CGSize(width: UIView.noIntrinsicMetric, height: 252.0)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            // ImageView "Avatar"
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120.0),
            // Button "Show Status"
            setStatusButton.heightAnchor.constraint(equalToConstant: 50.0),
            setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16.0),
            // Label "Username"
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27.0),
            fullNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // Label "Status"
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18.0),
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            // UITextField "statusField"
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12.0),
            statusTextField.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: setStatusButton.trailingAnchor),
            statusTextField.heightAnchor.constraint(equalToConstant: 40.0),
        ])
    }
    
    @objc func buttonPressed() {
        statusLabel.text = statusText
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = statusTextField.text ?? ""
    }
}

extension ProfileHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
