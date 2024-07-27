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
        return view
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(profileHeaderView)
        profileHeaderView.frame = CGRect(
            origin: CGPoint(
                x: 0.0,
                y: self.view.safeAreaInsets.top
            ),
            size: CGSize(
                width: self.view.frame.width,
                height: self.view.frame.height - self.view.safeAreaInsets.top
            )
        )
    }
}
