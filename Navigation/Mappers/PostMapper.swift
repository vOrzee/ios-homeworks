//
//  PostMapper.swift
//  Navigation
//
//  Created by Роман Лешин on 18.10.2024.
//

import Foundation
import CoreData
import StorageService

struct PostMapper {
    
    static func mapFromEntityToModel(_ entity: PostEntity) -> Post {
        return Post(
            id: Int(entity.id),
            author: entity.author ?? "",
            description: entity.descriptionPost ?? "",
            image: entity.imageSource ?? "",
            likes: String(entity.likesCount),
            views: String(entity.viewsCount)
        )
    }
    
    static func mapFromModelToEntity(_ post: Post, context: NSManagedObjectContext) -> PostEntity {
        let entity = PostEntity(context: context)
        entity.id = Int32(post.id)
        entity.author = post.author
        entity.descriptionPost = post.description
        entity.imageSource = post.image
        entity.likesCount = Int32(post.likes) ?? 0
        entity.viewsCount = Int32(post.views) ?? 0
        return entity
    }
}
