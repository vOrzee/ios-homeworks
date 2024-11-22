//
//  FeedModel.swift
//  Navigation
//
//  Created by Роман Лешин on 09.10.2024.
//
import Foundation

public class FeedModel {
    let secretWord: String
    
    init(secretWord: String = NSLocalizedString("gladiolus", comment: "")) {
        self.secretWord = secretWord
    }
}
