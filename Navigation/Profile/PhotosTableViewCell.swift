//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by Роман Лешин on 10.08.2024.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    private enum Constants {
        static let verticalSpacing: CGFloat = 12.0
        static let horizontalPadding: CGFloat = 12.0
        static let imageSpacing: CGFloat = 8.0
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let countPictures: CGFloat = 4.0
        static var imageSize: CGFloat = {
            (screenWidth - (imageSpacing*(countPictures-1) + horizontalPadding*2))/countPictures
        }()
    }
    
    private var photos: [UIImage?] = []
    
    private lazy var photosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = .black
        label.text = "Photos"
        return label
    }()
    
    private lazy var arrowRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")
        imageView.tintColor = .black
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentScrollView: UIView = {
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        
        return contentView
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: .subtitle,
            reuseIdentifier: reuseIdentifier
        )
        contentView.backgroundColor = .white
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let view = selectedBackgroundView else {
            return
        }
        
        contentView.insertSubview(view, at: 0)
        selectedBackgroundView?.isHidden = !selected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isHidden = false
        isSelected = false
        isHighlighted = false
    }
    
    func bind(photos: [UIImage?]) {
        self.photos = photos
        setupContentOfScrollView()
    }
    
    func addSubviews() {
        contentView.addSubview(photosLabel)
        contentView.addSubview(arrowRightImageView)
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(contentScrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photosLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            photosLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            scrollView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: Constants.verticalSpacing),
            scrollView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing),
            
            arrowRightImageView.centerYAnchor.constraint(equalTo: photosLabel.centerYAnchor),
            arrowRightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            
            contentScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupContentOfScrollView() {
        var previousImageView: UIImageView?
        for i in 0..<photos.count {
            let imageView = UIImageView()
            imageView.image = photos[i]

            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 6.0
            imageView.clipsToBounds = true
            
            contentScrollView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
                imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
                imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            ])
            
            if let previousImageView = previousImageView {
                imageView.leadingAnchor.constraint(equalTo: previousImageView.trailingAnchor, constant: Constants.imageSpacing).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor).isActive = true
            }
            
            previousImageView = imageView
        }

        contentScrollView.subviews.last?.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor).isActive = true
    }
}
