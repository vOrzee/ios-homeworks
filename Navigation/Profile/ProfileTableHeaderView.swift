//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Роман Лешин on 27.07.2024.
//

import UIKit
import StorageService

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
    
    lazy var setStatusButton: CustomButton = {
        let button = CustomButton(
            title: "Set status",
            titleColor: .white,
            backgroundColor: .blue,
            action: { [weak self] in
                guard let self = self else {return}
                self.statusLabel.text = self.statusText
            }
        )
        button.layer.cornerRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 4.0
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    init(avatarTapEvent: @escaping (UIImageView) -> Void, user: User) {
        super.init(frame: .zero)
        avatarImageView.image = user.avatar
        fullNameLabel.text = user.fullName
        statusLabel.text = user.status
        self.addSubview(avatarImageView)
        self.addSubview(fullNameLabel)
        self.addSubview(statusLabel)
        self.addSubview(statusTextField)
        self.addSubview(setStatusButton)
        self.backgroundColor = .lightGray
        setupConstraints()
        avatarTapEvent(avatarImageView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.circleCrop()
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
            setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0),
            // Label "Username"
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27.0),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16.0),
            fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            // Label "Status"
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18.0),
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            // UITextField "statusField"
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12.0),
            statusTextField.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: setStatusButton.trailingAnchor),
            statusTextField.heightAnchor.constraint(equalToConstant: 40.0),
        ])
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
