//
//  ProfileTableViewCell.swift
//  Navigation
//
//  Created by Роман Лешин on 03.08.2024.
//

import UIKit
import StorageService
import iOSIntPackage

class ProfileTableViewCell: UITableViewCell {
    
    private lazy var authorTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.textContainer.maximumNumberOfLines = 2
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        textView.textColor = .systemGray
        textView.backgroundColor = .clear
        textView.textContainer.maximumNumberOfLines = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    private lazy var likesLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var viewsLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .black
        return label
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
    
    func bind(_ post: Post) {
        authorTextView.text = post.author
        descriptionTextView.text = post.description
        likesLabelView.text = "Likes: \(post.likes)"
        viewsLabelView.text = "View: \(post.views)"
        
        let processor = ImageProcessor()
        
        if let image = UIImage(named: post.image) {
            // Применяем фильтр (например, Sepia)
            processor.processImage(sourceImage: image, filter: .noir) { filteredImage in
                pictureImageView.image = filteredImage
            }
        }
    }
    
    func addSubviews() {
        contentView.addSubview(authorTextView)
        contentView.addSubview(pictureImageView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(likesLabelView)
        contentView.addSubview(viewsLabelView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            authorTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            authorTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            authorTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            pictureImageView.topAnchor.constraint(equalTo: authorTextView.bottomAnchor),
            pictureImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pictureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pictureImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            pictureImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            descriptionTextView.topAnchor.constraint(equalTo: pictureImageView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            likesLabelView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16.0),
            likesLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            likesLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            viewsLabelView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16.0),
            viewsLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            viewsLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
        ])
    }

}
