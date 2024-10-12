//
//  FeedViewOutput.swift
//  Navigation
//
//  Created by Роман Лешин on 10.10.2024.
//

protocol FeedViewOutput {
    var state: FeedStateSecretWordCheck { get }
    var onRequestAction: (() -> Void)? { get set }
    func check(word: String?)
}
