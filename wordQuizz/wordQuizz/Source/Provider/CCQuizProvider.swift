//
//  CCProvider.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import Foundation

typealias CCHandler = (Data?, CCError?) -> Void

struct CCError {
    let error: Error
    let errorType: CCErrorType
}

enum CCErrorType {
    case genericError
    case parseError
}

class CCQuizProvider {
    
    let wordQuizJsonURL = "https://codechallenge.arctouch.com/quiz/1"
    
    func fetchWordQuiz(completion: @escaping CCHandler) {
        guard let url = URL(string: wordQuizJsonURL) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let wordsData = data {
                    completion(wordsData, nil)
                }
            } else {
                if let fetchError = error {
                    let currentError = CCError(error: fetchError, errorType: .genericError)
                    completion(nil, currentError)
                }
            }
        }
        
        task.resume()
    }
    
}
