//
//  CCQuizProviderMock.swift
//  wordQuizzTests
//
//  Created by Raphael Henrique Fontes Sil on 10/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import Foundation

@testable import wordQuizz

class CCQuizProviderMock: CCQuizProviderProtocol {
    
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func fetchWordQuiz(completion: @escaping CCHandler) {
        let data = getDataFromJsonFile()
        if let wordsData = data {
            completion(wordsData, nil)
        } else {
            let error = CCError(error: nil, errorType: .genericError)
            completion(nil, error)
        }
    }
    
    private func getDataFromJsonFile() -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {return nil}
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}
