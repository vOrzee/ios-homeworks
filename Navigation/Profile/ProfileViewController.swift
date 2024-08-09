//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Роман Лешин on 24.07.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let data: [Post] = posts
    
    private lazy var profileTable: UITableView = {
        let table = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .lightGray
        return table
    }()
    
    private enum CellReuseID: String {
        case post = "PostTableViewCell_ReuseID"
    }
    
    private enum HeaderFooterReuseID: String {
        case profileHeader = "ProfileHeader_TableSectionFooterHeaderView_ReuseID"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        navigationItem.title = "TableView example"
        navigationController?.navigationBar.prefersLargeTitles = false
        addSubviews()
        setupConstraints()
        tuneTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileTable.indexPathsForSelectedRows?.forEach{ indexPath in
            profileTable.deselectRow(
                at: indexPath,
                animated: animated
            )
        }
    }
    
    func addSubviews() {
        view.addSubview(profileTable)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            profileTable.topAnchor.constraint(equalTo: safeArea.topAnchor),
            profileTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            profileTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            profileTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    private func tuneTableView() {
        // 2. Настраиваем отображение таблицы
        profileTable.rowHeight = UITableView.automaticDimension
        profileTable.estimatedRowHeight = 44.0
        if #available(iOS 15.0, *) {
            profileTable.sectionHeaderTopPadding = 0.0
        }
        
        profileTable.tableFooterView = UIView()
        
        // 3. Указываем, с какими классами ячеек и кастомных футеров / хэдеров
        //    будет работать таблица
        profileTable.register(
            ProfileTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.post.rawValue
        )
        
        profileTable.register(
            TableSectionFooterHeaderView.self,
            forHeaderFooterViewReuseIdentifier: HeaderFooterReuseID.profileHeader.rawValue
        )
        
        // 4. Указываем основные делегаты таблицы
        profileTable.dataSource = self
        profileTable.delegate = self
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        data.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let viewHolder = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.post.rawValue,
            for: indexPath
        ) as? ProfileTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        viewHolder.bind(data[indexPath.row])
        
        return viewHolder
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: HeaderFooterReuseID.profileHeader.rawValue
        ) as? TableSectionFooterHeaderView else {
            fatalError("could not dequeueReusableCell")
        }

        headerView.setView(ProfileHeaderView())

        return headerView
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("Did select cell at \(indexPath)")
    }
}
