//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var changeStatusButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeTitleAction), for: .touchUpInside)
        button.backgroundColor = .orange
        button.setTitle("Изменить title", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4.0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Профиль"
        self.view.backgroundColor = .lightGray
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        
        addSubviews()
        applyConstraints()
    }
    
    func addSubviews() {
        view.addSubview(profileHeaderView)
        view.addSubview(changeStatusButton)
    }
    
    func applyConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220.0),
            profileHeaderView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            changeStatusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            changeStatusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            changeStatusButton.heightAnchor.constraint(equalToConstant: 40.0),
            changeStatusButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    @objc func changeTitleAction() {
        if(self.title == "Профиль") {
            self.title = "Изменённый title"
        } else {
            self.title = "Профиль"
        }
    }
}
