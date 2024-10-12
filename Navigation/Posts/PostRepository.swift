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
    func loadPosts(completion: @escaping (Result<Void, AppError>) -> Void)
    func getById(id: Int, completion: @escaping (Result<Post, AppError>) -> Void)
    func save(post: Post, completion: @escaping (Result<Void, AppError>) -> Void)
    func delete(id: Int, completion: @escaping (Result<Bool, AppError>) -> Void)
    func getNewerPosts(completion: @escaping (Result<[Post], AppError>) -> Void)
    func stopSubscribeNewPosts()
}
