//
//  PostViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit
import StorageService

class PostViewController: UIViewController {
    
    private let post: Post

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Информация"
        self.view.backgroundColor = .lightGray
        let barButtonItem = UIBarButtonItem(
            title: "Информация",
            style: .plain,
            target: self,
            action: #selector(openInfoViewController)
        )
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openInfoViewController() {
        let infoViewController = InfoViewController()
        
        infoViewController.modalTransitionStyle = .flipHorizontal
        infoViewController.modalPresentationStyle = .pageSheet
        
        present(infoViewController, animated: true)
    }

}
