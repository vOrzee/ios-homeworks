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
    
    func loadPosts(completion: @escaping (Result<Void, AppError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(3)
            if Int.random(in: 1...100) <= 20 {
                DispatchQueue.main.async {
                    completion(.failure(.networkUnavailable))
                }
                return
            }
            
            let posts = PostRepositoryInMemoryStorage.make()
            DispatchQueue.main.async {
                self._data = posts
            }
        }
    }
    
    func getById(id: Int, completion: @escaping (Result<Post, AppError>) -> Void) {
        DispatchQueue.global(qos: .background).async{
            sleep(3)
            guard let post = self._data.first(where: { $0.id == id }) else {
                DispatchQueue.main.async {
                    completion(.failure(.dataNotFound))
                }
                return
            }
            // Просто для демонстрации так как этот метод проще вызвать в текущей реализации:
            if Int.random(in: 1...100) <= 30 {
                DispatchQueue.main.async {
                    completion(.failure(.networkUnavailable))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(post))
            }
        }
    }
    
    func save(post: Post, completion: @escaping (Result<Void, AppError>) -> Void) {
        //This mock
        if Int.random(in: 1...100) <= 25 {
            return completion(.failure(.networkUnavailable))
        }
        print("Not yet implemented")
    }
    
    func delete(id: Int, completion: @escaping (Result<Bool, AppError>) -> Void) {
        //This mock
        if Int.random(in: 1...100) <= 40 {
            return completion(.failure(.networkUnavailable))
        }
        print("Not yet implemented")
        return completion(.success(true))
    }
    
    func getNewerPosts(completion: @escaping (Result<[Post], AppError>) -> Void) {
        DispatchQueue.global().async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) {_ in
                print("Запрос на получение постов отправлен")
                sleep(1)
                let newPosts = PostRepositoryInMemoryStorage.make()
                    .filter { post in
                        !self.data.contains(where: { $0.id == post.id })
                    }
                DispatchQueue.main.async {
                    print("Новые посты переданы в замыкание")
                    !newPosts.isEmpty ? completion(.success(newPosts)) : completion(.failure(.dataNotFound))
                }
            }
            self.timer?.tolerance = 3.0
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
