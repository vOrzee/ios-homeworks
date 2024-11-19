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
    
    private var postsEntity: [PostEntity] = [] // Пока оставлю так, потому что для удаления мне потребуется контекст вроде как, хотя потом всё равно можно будет поместить "под капот"
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
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseID.post.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postsEntity = CoreDataService.shared.fetchPosts()
        tableView.reloadData()
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
            CoreDataService.shared.deletePost(post: postToDelete)
            
            self.postsEntity.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

}
