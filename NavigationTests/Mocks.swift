//
//  Mock.swift
//  Navigation
//
//  Created by Роман Лешин on 24.11.2024.
//

@testable import Navigation
import Foundation

class MockNetworkLoader: NetworkLoaderProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var error: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
        MockURLSessionDataTask {
            completionHandler(self.mockData, self.mockResponse, self.error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let competion: () -> Void
    
    init(competion: @escaping () -> Void) {
        self.competion = competion
    }
    
    override func resume() {
        competion()
    }
}
