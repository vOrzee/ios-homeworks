//
//  NetworkServiceTest.swift
//  Navigation
//
//  Created by Роман Лешин on 24.11.2024.
//
#if !NO_TESTS
import XCTest
@testable import Navigation

class NetworkServiceTest: XCTestCase {
    
    var mockLoader: MockNetworkLoader!
    
    override func setUp() {
        super.setUp()
        mockLoader = MockNetworkLoader()
        NetworkService.loader = mockLoader
    }
    
    override func tearDown() {
        mockLoader = nil
        super.tearDown()
    }
    
    func testGetToDoTaskSuccess() async {
        let expectedTask = TodoTask(userId: 1, id: 1, title: "Первая задача", completed: false)
        let mockJSON = "{\"userId\": 1, \"id\": 1, \"title\": \"Первая задача\", \"completed\": false}"
        mockLoader.mockData = mockJSON.data(using: .utf8)
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            XCTFail("Invalid URL")
            return
        }
        mockLoader.mockResponse = HTTPURLResponse(
            url: url, statusCode: 200, httpVersion: "1.1", headerFields: nil
        )
        
        let expectation = XCTestExpectation(description: "Ожидание ответа для парсинга")
        
        await NetworkService.getToDoTask(withId: 1) { result in
            switch result {
            case .success(let task):
                XCTAssertEqual(expectedTask, task)
                expectation.fulfill()
            case .failure:
                XCTFail("Ошибка")
            }
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testGetToDoTaskNetworkError() async {
        mockLoader.error = NSError(domain: "Invalid request", code: 404)
        let expectation = XCTestExpectation(description: "Ожидание ответа для парсинга")
        
        await NetworkService.getToDoTask(withId: 1) { result in
            switch result {
            case .success:
                XCTFail("Результат должен был быть провальным")
            case .failure(let error):
                XCTAssertEqual(AppError.networkUnavailable(NSLocalizedString("Network unavailable", comment: "")), error)
                expectation.fulfill()
            }
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testGetToDoTaskInvalidJSON() async {
        let mockJSON = "{\"data\": \"Not found\"}"
        mockLoader.mockData = mockJSON.data(using: .utf8)
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
            XCTFail("Invalid URL")
            return
        }
        mockLoader.mockResponse = HTTPURLResponse(
            url: url, statusCode: 200, httpVersion: "1.1", headerFields: nil
        )
        
        let expectation = XCTestExpectation(description: "Ожидание ответа для парсинга")
        
        await NetworkService.getToDoTask(withId: 1) { result in
            switch result {
            case .success:
                XCTFail("Результат должен был быть провальным")
            case .failure(let error):
                XCTAssertEqual(AppError.dataNotFound, error)
                expectation.fulfill()
            }
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}
#endif
