//
//  ImageView.swift
//  Navigation
//
//  Created by Роман Лешин on 28.07.2024.
//

import UIKit

extension UIImageView {
    func circleCrop() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
