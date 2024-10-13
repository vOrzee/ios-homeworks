//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Роман Лешин on 03.08.2024.
//

import UIKit

class TableSectionFooterHeaderView: UITableViewHeaderFooterView {

    // MARK: - Subviews
    
    private lazy var headerFooterView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        tuneView()
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setView(_ view: UIView) {
        headerFooterView.removeFromSuperview()
        headerFooterView = view
        headerFooterView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func tuneView() {
        contentView.backgroundColor = .clear
    }
    
    private func addSubviews() {
        contentView.addSubview(headerFooterView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerFooterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerFooterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerFooterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerFooterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return headerFooterView.intrinsicContentSize
    }
}
