//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

class FeedViewModel: FeedViewOutput {
    private var feedModel: FeedModel
    
    var state: FeedStateWordCheck = .uncorrect {
        didSet {
            onRequestAction?()
        }
    }
    
    var onRequestAction: (() -> Void)?
    
    init(feedModel: FeedModel = FeedModel()) {
        self.feedModel = feedModel
    }
    
    func check(word: String?) {
        guard let word = word, !word.isEmpty else {
            state = .uncorrect
            return
        }
        
        let result = word.lowercased() == feedModel.secretWord.lowercased()
        state = result ? .correct : .uncorrect
    }
}
