//
//  ViewModelState.swift
//  Navigation
//
//  Created by Роман Лешин on 12.10.2024.
//

enum ViewModelState: Equatable {
    case idle
    case loading
    case error(String, AppError?)
}
