//
//  wordQuizzTests.swift
//  wordQuizzTests
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import XCTest
@testable import wordQuizz

class CCQuizzManagerTests: XCTestCase, CCQuizManagerDelegate {

    var manager: CCQuizManager!
    
    private var didFetchExpectation: XCTestExpectation!
    private var quizViewModel: CCQuizViewModel!
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    func testValidResponse() {
        didFetchExpectation = XCTestExpectation(description: "didFetchExpectation")
        let provider = CCQuizProviderMock(fileName: "success")
        let manager = CCQuizManager(delegate: self, provider: provider)
        
        manager.fetchWordQuiz()
        
        wait(for: [didFetchExpectation], timeout: 2)
        
        XCTAssertEqual(quizViewModel.question, "What are all the java keywords?")
    }

    func didFetchQuiz(_ quiz: CCQuizViewModel) {
        self.quizViewModel = quiz
        didFetchExpectation.fulfill()
    }
    
    func errorToFetch(_ error: CCError) {
        print("error")
    }
    
}
