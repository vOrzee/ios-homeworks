//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Роман Лешин on 27.07.2024.
//

import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    
    private var statusText: String = "Waiting for something..."
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
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
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .black
        label.text = "Hipster Cat"
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray
        label.text = statusText
        return label
    }()
    
    lazy var statusTextField: UITextField = {
        let textField = UITextField()
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
    
    init(avatarTapEvent: @escaping (UIImageView) -> Void) {
        super.init(frame: .zero)
        self.addSubview(avatarImageView)
        self.addSubview(fullNameLabel)
        self.addSubview(statusLabel)
        self.addSubview(statusTextField)
        self.addSubview(setStatusButton)
        self.backgroundColor = .lightGray
        setupConstraints()
        avatarTapEvent(avatarImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.circleCrop()
    }
    
    func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.leading.equalToSuperview().offset(16.0)
            make.width.height.equalTo(120.0)
        }
        
        setStatusButton.snp.makeConstraints { make in
            make.height.equalTo(50.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(statusTextField.snp.bottom).offset(16.0)
            make.bottom.equalToSuperview().inset(16.0)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.0)
            make.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(avatarImageView.snp.bottom).offset(-18.0)
            make.leading.equalTo(fullNameLabel.snp.leading)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(12.0)
            make.leading.equalTo(statusLabel.snp.leading)
            make.trailing.equalTo(setStatusButton.snp.trailing)
            make.height.equalTo(40.0)
        }
    }
    
    @objc func buttonPressed() {
        statusLabel.text = statusText
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = statusTextField.text ?? ""
    }
}

extension ProfileHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

