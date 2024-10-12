//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {
    
    var coordinator: ProfileCoordinator?
    
    private var postViewModel: PostViewOutput
    
    private var user: User
    
    private var avatarTapEvent: ((UIImageView) -> Void)?

    private lazy var profileTable: UITableView = {
        let table = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .lightGray
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        indicator.style = .medium
        return indicator
    }()
    
    private enum CellReuseID: String {
        case post = "PostTableViewCell_ReuseID"
        case photos = "PhotosTableViewCell_ReuseID"
    }
    
    init(user: User, postViewOutput: PostViewOutput) {
        self.user = user
        self.postViewModel = postViewOutput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        view.backgroundColor = .systemGray2
        #else
        view.backgroundColor = .lightGray
        #endif
        navigationItem.title = "TableView example"
        navigationController?.navigationBar.prefersLargeTitles = false
        addSubviews()
        setupConstraints()
        tuneTableView()
        avatarTapEvent = { imageView in
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(self.avatarTapped(_:))
            )
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileTable.indexPathsForSelectedRows?.forEach{ indexPath in
            profileTable.deselectRow(
                at: indexPath,
                animated: animated
            )
        }
        
        postViewModel.onDataChanged = { [weak self] updatedPosts in // Своеобразная лайвдата
            guard let self else {return}
            self.profileTable.reloadData()
        }
        
        postViewModel.subscribeNewPosts { [weak self] newPosts in
            guard !newPosts.isEmpty else { return }
            guard let self else { return }
            
            let alert = UIAlertController(
                title: "Новые посты",
                message: "Появились новые посты. Хотите обновить список?",
                preferredStyle: .alert
            )
            
            let refreshAction = UIAlertAction(title: "Обновить", style: .default) { [weak self] _ in
                guard let self else { return }
                print(self.postViewModel.getAllPosts())
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alert.addAction(refreshAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        postViewModel.onStateChange = { [weak self] state in
            guard let self else {return}
            switch state {
            case .loading:
                self.activityIndicator.startAnimating()
            case .idle:
                self.activityIndicator.stopAnimating()
            case .error(let message, let error):
                self.activityIndicator.stopAnimating()
                if error == .dataNotFound {
                    print(message)
                    break
                }
                let alert = UIAlertController(
                    title: "Ошибка",
                    message: message,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        postViewModel.invalidateSubscribeNewPosts()
        postViewModel.onDataChanged = nil
        postViewModel.onStateChange = nil
    }
    
    func addSubviews() {
        view.addSubview(profileTable)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            profileTable.topAnchor.constraint(equalTo: safeArea.topAnchor),
            profileTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            profileTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            profileTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    private func tuneTableView() {
        // 2. Настраиваем отображение таблицы
        profileTable.rowHeight = UITableView.automaticDimension
        profileTable.estimatedRowHeight = 44.0
        if #available(iOS 15.0, *) {
            profileTable.sectionHeaderTopPadding = 0.0
        }
        
        profileTable.tableFooterView = UIView()
        
        // 3. Указываем, с какими классами ячеек и кастомных футеров / хэдеров
        //    будет работать таблица
        profileTable.register(
            ProfileTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.post.rawValue
        )
        profileTable.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.photos.rawValue
        )
        
        // 4. Указываем основные делегаты таблицы
        profileTable.dataSource = self
        profileTable.delegate = self
    }
    
    @objc func avatarTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
        let originalFrame = imageView.convert(imageView.bounds, to: self.view)
        
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.view.addSubview(overlayView)
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.alpha = 0.0
        closeButton.frame = CGRect(x: self.view.bounds.width - 48, y: 48, width: 32, height: 32)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        let animatedImageView = UIImageView(image: imageView.image)
        animatedImageView.frame = originalFrame
        animatedImageView.layer.cornerRadius = imageView.layer.cornerRadius
        animatedImageView.clipsToBounds = true
        self.view.addSubview(animatedImageView)
        
        imageView.isHidden = true

        UIView.animate(withDuration: 0.5, animations: {
            animatedImageView.frame = CGRect(
                x: 0,
                y: (self.view.frame.height - self.view.frame.width) / 2,
                width: self.view.frame.width,
                height: self.view.frame.width * (originalFrame.height / originalFrame.width)
            )
            animatedImageView.layer.cornerRadius = 0
            
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                closeButton.alpha = 1.0
            }
        }
        
        closeButton.tag = 100
        animatedImageView.tag = 101
        overlayView.tag = 102
        imageView.tag = 103
    }

    @objc private func closeButtonTapped(_ sender: UIButton) {
        guard let animatedImageView = self.view.viewWithTag(101) as? UIImageView,
              let overlayView = self.view.viewWithTag(102),
              let originalImageView = self.view.viewWithTag(103) as? UIImageView else {
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            sender.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                animatedImageView.frame = originalImageView.convert(originalImageView.bounds, to: self.view)
                animatedImageView.layer.cornerRadius = originalImageView.layer.cornerRadius
            }) { _ in
                animatedImageView.removeFromSuperview()
                overlayView.removeFromSuperview()
                sender.removeFromSuperview()
                originalImageView.isHidden = false
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        postViewModel.data.count + 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let viewHolder = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.photos.rawValue,
                for: indexPath
            ) as? PhotosTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            viewHolder.bind(photos: PhotosRepository.make())
            return viewHolder
        }
        
        guard let viewHolder = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.post.rawValue,
            for: indexPath
        ) as? ProfileTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        viewHolder.bind(postViewModel.data[indexPath.row - 1])
        
        return viewHolder
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let avatarTapEvent = avatarTapEvent else {return nil}
        return ProfileHeaderView(avatarTapEvent: avatarTapEvent, user: user)
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row == 0 {
            coordinator?.showPhotos(photos: PhotosRepository.make())
        }
    }
}
