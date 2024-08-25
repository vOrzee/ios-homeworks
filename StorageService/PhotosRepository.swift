//
//  PhotosRepository.swift
//  Navigation
//
//  Created by Роман Лешин on 10.08.2024.
//

import UIKit

public enum PhotosRepository {
    public static func make() -> [UIImage?] {
        return (1...10).map {
            UIImage(named: "IT_theme_square_image_\($0)")
        } + (1...5).map {
            UIImage(named: "iOS_theme_square_image_\($0)")
        } + (1...5).map {
            UIImage(named: "Android_theme_square_image_\($0)")
        }
    }
}
