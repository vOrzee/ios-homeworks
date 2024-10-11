//
//  PostViewOutput.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import StorageService

protocol PostViewOutput {
    var data: [Post] { get }
    var state: ViewModelState { get }
    var onStateChange: ((ViewModelState) -> Void)? { get set }
    var onDataChanged: (([Post]) -> Void)? { get set }
    var repository: PostRepository { get }
    func getAllPosts()
    func getPostById(id: Int, completion: @escaping (Post?) -> Void)
    func subscribeNewPosts(uiAction: @escaping (([Post])->Void))
    func invalidateSubscribeNewPosts()
}
