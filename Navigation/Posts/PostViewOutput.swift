//
//  PostViewOutput.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import StorageService

protocol PostViewOutput {
    var data: [Post] {get}
    var onDataChanged: (([Post]) -> Void)? { get set }
    var repository: PostRepository { get }
    func getAllPosts() -> [Post]
    func getPostById(id: Int) -> Post?
}
