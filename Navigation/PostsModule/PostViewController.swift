//
//  PostViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit
import StorageService

class PostViewController: UIViewController {
    
    var coordinator: PostCoordinator?
    
    private let post: Post
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .black
        return label
    }()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .black
        return label
    }()
    
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
        
        view.addSubview(authorLabel)
        view.addSubview(postImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(likesLabel)
        view.addSubview(viewsLabel)
        
        setupConstraints()
        bindPostData()
    }
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openInfoViewController() {
        coordinator?.showInfo()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postImageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.75),
            descriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func bindPostData() {
        authorLabel.text = post.author
        postImageView.image = UIImage(named: post.image)
        descriptionLabel.text = post.description
        likesLabel.text = "Likes: \(post.likes)"
        viewsLabel.text = "Views: \(post.views)"
    }
}
