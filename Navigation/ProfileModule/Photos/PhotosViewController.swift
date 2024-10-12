//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 10.08.2024.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    private var photos: [UIImage] = []
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self)
        )
        
        return collectionView
    }()
    
    init(photos: [UIImage?]) {
        let imageProcessor = ImageProcessor()
        self.photos = photos.compactMap { $0 }
        super.init(nibName: nil, bundle: nil)
        let qos: QualityOfService = .userInteractive
        let startTime = DispatchTime.now().uptimeNanoseconds / 1_000_000
        imageProcessor.processImagesOnThread(
            sourceImages: self.photos,
            filter: .chrome,
            qos: qos,
            completion:  { [weak self] photosWithFilterTypedCGImages in
                guard let self = self else { return }
                let photosWithFilter = photosWithFilterTypedCGImages.compactMap { cgImage in
                    cgImage.map { UIImage(cgImage: $0) }
                }
                DispatchQueue.main.async {
                    self.photos = photosWithFilter
                    self.collectionView.reloadData()
                    let completionTime = DispatchTime.now().uptimeNanoseconds / 1_000_000 - startTime
                    print("Применение фильтров с qos \(qos.rawValue) заняло \(completionTime) мс")
                }
            }
        )
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationController?.navigationBar.isHidden = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Photo Gallery"
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: PhotosCollectionViewCell.self),
            for: indexPath
        ) as? PhotosCollectionViewCell else {
            fatalError("Unable to dequeue PhotosCollectionViewCell")
        }
        
        cell.bind(uiImage: photos[indexPath.item])
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    private enum Constants {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let imageCountInRow: CGFloat = 3.0
        static let spacing: CGFloat = 8.0
        
        static var imageSize: CGFloat = {
            return (screenWidth - spacing * (imageCountInRow + 1.0)) / imageCountInRow
        }()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Constants.imageSize, height: Constants.imageSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Constants.spacing, left: Constants.spacing, bottom: Constants.spacing, right: Constants.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.spacing
    }
}
