//
//  PostViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 09.12.2023.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = post?.title
        view.backgroundColor = .systemGray3
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Информация",
            style: .plain,
            target: self,
            action: #selector(openInfoViewController)
        )
        
    }
    
    @objc func openInfoViewController() {
        let infoViewController = InfoViewController()
        
        infoViewController.modalTransitionStyle = .flipHorizontal
        infoViewController.modalPresentationStyle = .formSheet
        
        present(infoViewController, animated: true)
    }
}
