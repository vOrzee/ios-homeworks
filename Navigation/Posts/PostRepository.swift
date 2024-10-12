//
//  PostRepository.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import StorageService

protocol PostRepository {
    var data: [Post] { get }
    var onDataChanged: (([Post]) -> Void)? { get set }
    func getAll()
    func getById(id: Int) -> Post?
    func save(post: Post)
    func delete(id: Int)
    func getNewerPosts(completion: @escaping ([Post]) -> Void)
    func stopSubscribeNewPosts()
}
