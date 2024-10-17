//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 17.10.2024.
//

import UIKit
import StorageService

class FavoriteViewController: UITableViewController {
    
    var coordinator: FavoritesCoordinator?
    
    private var shadowUpdate = false
    private var postsEntity: [PostEntity] = []
    private var authorFilterFavorite: String = UserDefaults.standard.string(forKey: "authorFilterFavorite") ?? "" {
        didSet {
            UserDefaults.standard.set(authorFilterFavorite, forKey: "authorFilterFavorite")
            Task {
                postsEntity = await CoreDataService.shared.fetchPosts()
                tableView.reloadData()
            }
        }
    }
    private var posts: [Post] {
        postsEntity.map { postEntity in
            PostMapper.mapFromEntityToModel(postEntity)
        }
    }
    
    private enum CellReuseID: String {
        case post = "PostTableViewCell_ReuseID"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сохранённое"
        view.backgroundColor = .systemGray6
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseID.post.rawValue)
        let clearBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .done, target: self, action: #selector(clearFilter))
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(applyFilter))
        
        navigationItem.rightBarButtonItems = [clearBarButtonItem, searchBarButtonItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            postsEntity = await CoreDataService.shared.fetchPosts()
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewHolder = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.post.rawValue,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        viewHolder.bind(posts[indexPath.row])
        
        return viewHolder
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let postToDelete = self.postsEntity[indexPath.row]
            Task {
                await CoreDataService.shared.deletePost(post: postToDelete)
                self.postsEntity.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    @objc func clearFilter() {
        authorFilterFavorite = ""
    }
    
    @objc func applyFilter() {
        let alertController = UIAlertController(title: "Поиск по автору", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите имя автора"
        }
        let searchAction = UIAlertAction(title: "Применить", style: .default) { [weak self] _ in
            guard let self = self, let authorName = alertController.textFields?.first?.text, !authorName.isEmpty else {
                return
            }
            authorFilterFavorite = authorName
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
