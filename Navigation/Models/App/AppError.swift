//
//  AppError.swift
//  Navigation
//
//  Created by Роман Лешин on 11.10.2024.
//

enum AppError: Error, Equatable {
    case networkUnavailable(String = "")
    case unauthorized
    case dataNotFound
    case unknownError
}
