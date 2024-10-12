//
//  PostViewModel.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//
import StorageService

class PostViewModel: PostViewOutput {
    static let shared: PostViewOutput = PostViewModel()
    
    var repository: PostRepository = PostRepositoryInMemory()
    
    var data: [Post] {
        return repository.data
    }
    
    var state: FeedViewModelState {
        return _state
    }
    
    private var _state: FeedViewModelState = .idle {
        didSet {
            onStateChange?(_state)
            if _state != .loading {
                _state = .idle
            }
        }
    }
    
    var onDataChanged: (([Post]) -> Void)? {
        didSet {
            repository.onDataChanged = onDataChanged
        }
    }
    var onStateChange: ((FeedViewModelState) -> Void)?
    
    private init() {
        getAllPosts()
        repository.onDataChanged = { [weak self] updatedData in
            self?.onDataChanged?(updatedData)
        }
    }
    
    func getAllPosts() {
        _state = .loading
        repository.loadPosts { result in
            switch result {
            case .success: self._state = .idle
            case .failure(let error):
                self._state = .error("Ошибка при загрузке постов: \(error)", error)
            }
        }
    }
    
    func getPostById(id: Int, completion: @escaping (Post?) -> Void) {
        _state = .loading
        repository.getById(id: id) { result in
            switch result {
            case .success(let post):
                self._state = .idle
                completion(post)
            case .failure(let error):
                switch error {
                case .dataNotFound:
                    self._state = .error("Пост с таким id не найден", error)
                    completion(nil)
                case .networkUnavailable:
                    self._state = .error("Ошибка при загрузке поста: \(error)", error)
                    completion(nil)
                default: completion(nil)
                }
            }
        }
    }
    
    func subscribeNewPosts(uiAction: @escaping (([Post])->Void)) {
        _state = .loading
        repository.getNewerPosts { result in
            switch result {
            case .success(let newPosts):
                uiAction(newPosts)
                self._state = .idle
            case .failure(let error):
                switch error {
                case .dataNotFound: self._state = .error("Новых постов не найдено", error)
                case .networkUnavailable: self._state = .error("Ошибка при загрузке постов: \(error)", error)
                default: break
                }
            }
        }
    }
    
    func invalidateSubscribeNewPosts() {
        repository.stopSubscribeNewPosts()
    }
    
}
