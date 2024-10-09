//
//  FeedModel.swift
//  Navigation
//
//  Created by Роман Лешин on 09.10.2024.
//

public class FeedModel {
    private var secretWord: String
    
    init(secretWord: String) {
        self.secretWord = secretWord
    }
    
    public func check(word: String) -> Bool {
        word.uppercased() == secretWord.uppercased()
    }
}
