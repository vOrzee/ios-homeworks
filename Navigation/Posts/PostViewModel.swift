//
//  PostViewModel.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//
import StorageService

class PostViewModel: PostViewOutput {
    var repository: PostRepository = PostRepositoryInMemory()
    
    var data: [Post] {
        return repository.data
    }
    
    var onDataChanged: (([Post]) -> Void)? {
        didSet {
            repository.onDataChanged = onDataChanged
        }
    }
    
    init() {
        repository.onDataChanged = { [weak self] updatedData in
            self?.onDataChanged?(updatedData)
        }
    }
    
    func getAllPosts() -> [Post] {
        repository.getAll()
        return data
    }
    
    func getPostById(id: Int) -> Post? {
        return repository.getById(id: id)
    }
    
    func subscribeNewPosts(uiAction: @escaping (([Post])->Void)) {
        repository.getNewerPosts(completion: uiAction)
    }
    
    func invalidateSubscribeNewPosts() {
        repository.stopSubscribeNewPosts()
    }
    
}
