//
//  PostRepositoryIM.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

import StorageService

class PostRepositoryInMemory: PostRepository {
    
    var data: [Post] {
        return _data
    }
    
    private var _data: [Post] {
        didSet {
            onDataChanged?(_data)
        }
    }
    
    var onDataChanged: (([Post]) -> Void)?
    
    init() {
        _data = PostRepositoryInMemoryStorage.make()
    }
    
    func getAll() {
        _data = PostRepositoryInMemoryStorage.make()
    }
    
    func getById(id: Int) -> Post? {
        let post = _data.first(where: { $0.id == id })
        return post
    }
    
    func save(post: Post) {
        //This mock
        print("Not yet implemented")
    }
    
    func delete(id: Int) {
        //This mock
        print("Not yet implemented")
    }
}
