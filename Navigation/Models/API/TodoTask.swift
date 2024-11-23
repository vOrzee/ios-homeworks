//
//  TodoTask.swift
//  Navigation
//
//  Created by Роман Лешин on 13.10.2024.
//

struct TodoTask: Codable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
