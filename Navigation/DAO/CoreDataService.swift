//
//  CoreDataService.swift
//  Navigation
//
//  Created by Роман Лешин on 17.10.2024.
//

import Foundation
import CoreData
import StorageService

final class CoreDataService {
    static let shared = CoreDataService()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Navigation") 
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchPosts() -> [PostEntity] {
        let request = PostEntity.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    func addPost(post: Post) {
        let postEntity = PostEntity(context: persistentContainer.viewContext)
        postEntity.id = Int32(post.id)
        postEntity.author = post.author
        postEntity.descriptionPost = post.description
        postEntity.imageSource = post.image
        postEntity.likesCount = Int32(post.likes) ?? 0
        postEntity.viewsCount = Int32(post.views) ?? 0
        try? persistentContainer.viewContext.save()
    }
    
    func deletePost(post: PostEntity) {
        let context = post.managedObjectContext
        context?.delete(post)
        try? context?.save()
    }
}
