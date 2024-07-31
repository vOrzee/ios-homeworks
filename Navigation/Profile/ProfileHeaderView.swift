//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Роман Лешин on 27.07.2024.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private var statusText: String = "Waiting for something..."
    
    lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = imageView.frame.height / 2
//        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        
        if let image = UIImage(named: "HipsterCat") {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        
        return imageView
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .black
        label.text = "Hipster Cat"
        return label
    }()
    
    lazy var status: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray
        label.text = statusText
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(showStatusField))
        )
        return label
    }()
    
    lazy var btnShowStatus: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 4.0
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowOpacity = 0.7
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var statusField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(
            self,
            action: #selector(statusTextChanged),
            for: .editingChanged
        )
        textField.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        textField.textColor = .black
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 12.0
        textField.backgroundColor = .white
        textField.isHidden = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.rightViewMode = .always
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatar)
        self.addSubview(userName)
        self.addSubview(status)
        self.addSubview(btnShowStatus)
        self.addSubview(statusField)
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.circleCrop()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var btnShowTopAnchorWithStatusField: NSLayoutConstraint!
    private var btnShowTopAnchorWithAvatar: NSLayoutConstraint!
    func applyConstraints(){
        NSLayoutConstraint.activate([
            // ImageView "Avatar"
            avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            avatar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            avatar.widthAnchor.constraint(equalToConstant: 120.0),
            avatar.heightAnchor.constraint(equalToConstant: 120.0),
            // Button "Show Status"
            btnShowStatus.heightAnchor.constraint(equalToConstant: 50.0),
            btnShowStatus.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            btnShowStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            // Label "Username"
            userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 27.0),
            userName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // Label "Status"
            status.bottomAnchor.constraint(equalTo: avatar.bottomAnchor, constant: -18.0),
            status.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
            // UITextField "statusField"
            statusField.topAnchor.constraint(equalTo: status.bottomAnchor, constant: 12.0),
            statusField.leadingAnchor.constraint(equalTo: status.leadingAnchor),
            statusField.trailingAnchor.constraint(equalTo: btnShowStatus.trailingAnchor),
            statusField.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        btnShowTopAnchorWithStatusField = btnShowStatus.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 16.0)
        btnShowTopAnchorWithAvatar = btnShowStatus.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 16.0)
        applyButtonTopAnchorConstraints()
    }
    
    func applyButtonTopAnchorConstraints() {
        if statusField.isHidden {
            btnShowTopAnchorWithStatusField.isActive = false
            btnShowTopAnchorWithAvatar.isActive = true
        } else {
            btnShowTopAnchorWithAvatar.isActive = false
            btnShowTopAnchorWithStatusField.isActive = true
        }
        self.layoutIfNeeded()
    }
    
    @objc func buttonPressed() {
        status.text = statusText
        hideStatusField()
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    @objc func hideStatusField() {
        statusField.isHidden = true
        statusField.text = ""
        applyButtonTopAnchorConstraints()
    }
    
    @objc func showStatusField() {
        statusField.isHidden = false
        applyButtonTopAnchorConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
        if !statusField.isHidden { hideStatusField() }
    }
}
