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
    
    private var _data: [Post] = [] {
        didSet {
            onDataChanged?(_data)
        }
    }
    
    var onDataChanged: (([Post]) -> Void)?
    
    private var timer: Timer?
    
    init() {
        getAll()
    }
    
    func getAll() {
        DispatchQueue.global(qos: .background).async {
            let posts = PostRepositoryInMemoryStorage.make()
            DispatchQueue.main.async {
                self._data = posts
            }
        }
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
    
    func getNewerPosts(completion: @escaping ([Post]) -> Void) {
        DispatchQueue.global().async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) {_ in
                print("Запрос на получение постов отправлен")
                let newPosts = PostRepositoryInMemoryStorage.make()
                    .filter { post in
                        !self.data.contains(where: { $0.id == post.id })
                    }
                DispatchQueue.main.async {
                    print("Новые посты переданы в замыкание")
                    completion(newPosts)
                }
            }
            RunLoop.current.add(self.timer!, forMode: .default)
            RunLoop.current.run()
        }
    }
    
    func stopSubscribeNewPosts() {
        timer?.invalidate()
        timer = nil
        print("Подписка отменена")
    }
}
