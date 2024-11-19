//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 17.10.2024.
//

import UIKit
import StorageService
import CoreData

class FavoriteViewController: UITableViewController {
    
    var coordinator: FavoritesCoordinator?
    private lazy var fetchedResultsController = {
        let request = PostEntity.fetchRequest()
        
        let authorFilter = UserDefaults.standard.string(forKey: "authorFilterFavorite") ?? ""
        if !authorFilter.isEmpty {
            request.predicate = NSPredicate(format: "author CONTAINS[c] %@", authorFilter)
        }

        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataService.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        return fetchedResultsController
    }()
    private var authorFilterFavorite: String = UserDefaults.standard.string(forKey: "authorFilterFavorite") ?? "" {
        didSet {
            UserDefaults.standard.set(authorFilterFavorite, forKey: "authorFilterFavorite")
            clearBarButtonItem.isHidden = authorFilterFavorite.isEmpty
            setupFetchedResultsController()
        }
    }
    
    private enum CellReuseID: String {
        case post = "PostTableViewCell_ReuseID"
    }
    private var clearBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    private var searchBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewHolder = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.post.rawValue,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        let postEntity = fetchedResultsController.object(at: indexPath)
        viewHolder.bind(PostMapper.mapFromEntityToModel(postEntity))
        
        return viewHolder
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let postToDelete = self.fetchedResultsController.object(at: indexPath)
            Task {
                await CoreDataService.shared.deletePost(post: postToDelete)
            }

            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    
    private func setupUI() {
        title = "Сохранённое"
        view.backgroundColor = .systemGray6
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseID.post.rawValue)
        
        clearBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .done, target: self, action: #selector(clearFilter))
        searchBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(applyFilter))
        clearBarButtonItem.isHidden = authorFilterFavorite.isEmpty
        
        navigationItem.rightBarButtonItems = [clearBarButtonItem, searchBarButtonItem]
    }
    
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        
        if !authorFilterFavorite.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "author CONTAINS[c] %@", authorFilterFavorite)
        }

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataService.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
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


extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
