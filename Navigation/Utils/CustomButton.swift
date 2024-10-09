//
//  CustomButton.swift
//  Navigation
//
//  Created by Роман Лешин on 09.10.2024.
//

import UIKit

class CustomButton: UIButton {
    
    private var action: (() -> Void)?
    
    public init(title: String, titleColor: UIColor, backgroundColor: UIColor? = nil, action: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.action = action
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        action?()
    }
    
}
