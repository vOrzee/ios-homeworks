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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Navigation") 
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    private init() {}
    
    func addPost(post: Post) async {
        let postEntity = PostEntity(context: backgroundContext)
        postEntity.id = Int32(post.id)
        postEntity.author = post.author
        postEntity.descriptionPost = post.description
        postEntity.imageSource = post.image
        postEntity.likesCount = Int32(post.likes) ?? 0
        postEntity.viewsCount = Int32(post.views) ?? 0
        await backgroundContext.perform {
            try? self.backgroundContext.save()
        }
    }
    
    func deletePost(post: PostEntity) async {
        let context = post.managedObjectContext ?? backgroundContext
        await context.perform {
            context.delete(post)
            try? context.save()
        }
    }
}
