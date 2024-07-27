//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Роман Лешин on 27.07.2024.
//

import UIKit

class ProfileHeaderView: UIView {
    
    lazy var avatar: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 120.0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 60.0
        imageView.layer.masksToBounds = true
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
        label.text = "Waiting for something..."
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(avatar)
        self.addSubview(userName)
        self.addSubview(status)
        self.addSubview(btnShowStatus)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
            btnShowStatus.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 16.0),
            // Label "Username"
            userName.topAnchor.constraint(equalTo: self.topAnchor, constant: 27.0),
            userName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // Label "Status"
            status.bottomAnchor.constraint(equalTo: btnShowStatus.topAnchor, constant: -34.0),
            status.leadingAnchor.constraint(equalTo: userName.leadingAnchor),
        ])
    }
    
    @objc func buttonPressed() {
        print(status.text ?? "")
    }

}
