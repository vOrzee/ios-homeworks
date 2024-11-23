//
//  NetworkLoaderProtocol.swift
//  Navigation
//
//  Created by Роман Лешин on 24.11.2024.
//

import Foundation

protocol NetworkLoaderProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void
    ) -> URLSessionDataTask
}
