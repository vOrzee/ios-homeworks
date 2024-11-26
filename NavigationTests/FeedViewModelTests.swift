//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by Роман Лешин on 24.11.2024.
//
import XCTest
@testable import Navigation

class FeedViewModelTests: XCTestCase {

    var viewModel: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FeedViewModel(feedModel: FeedModel(secretWord: "панамка"))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCheckCorrectWord() {
        viewModel.check(word: "панамка")
        XCTAssertEqual(viewModel.state, .correct)
    }

    func testCheckUncorrectWord() {
        viewModel.check(word: "кепка")
        XCTAssertEqual(viewModel.state, .uncorrect)
    }
    
    func testOnRequestActionCalled() {
        var isCalled = false
        viewModel.onRequestAction = {
            isCalled = true
        }
        
        viewModel.check(word: "панамка")
        XCTAssertTrue(isCalled)
    }
}
