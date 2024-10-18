//
//  Post.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import Foundation

public struct Post {
    public let id: Int
    public let author: String
    public let description: String
    public let image: String
    public var likes: String
    public var views: String
    public init(id: Int, author: String, description: String, image: String, likes: String, views: String) {
        self.id = id
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}
