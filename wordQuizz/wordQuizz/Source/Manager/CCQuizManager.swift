//
//  CCQuizManager.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import Foundation

protocol CCQuizManagerDelegate {
    func didFetchQuiz(_ quiz: CCQuizViewModel)
    func errorToFetch(_ error: CCError)
}

class CCQuizManager {
    
    private let provider: CCQuizProviderProtocol
    var delegate: CCQuizManagerDelegate?
    
    init(delegate: CCQuizManagerDelegate? = nil, provider: CCQuizProviderProtocol = CCQuizProvider()) {
        self.provider = provider
        self.delegate = delegate
    }
    
    func fetchWordQuiz() {
        provider.fetchWordQuiz { [weak self] (data, error) in
            if let wordsData = data {
                do {
                    let quiz = try JSONDecoder().decode(CCQuizModel.self, from: wordsData)
                    
                    if let quizViewModel = self?.wrapToViewModel(quiz: quiz) {
                        self?.delegate?.didFetchQuiz(quizViewModel)
                    }
                } catch {
                    let currentError = CCError(error: error, errorType: .parseError)
                    self?.delegate?.errorToFetch(currentError)
                }
            } else {
                let currentError = CCError(error: nil, errorType: .genericError)
                self?.delegate?.errorToFetch(currentError)
            }
        }
    }
    
    private func wrapToViewModel(quiz: CCQuizModel) -> CCQuizViewModel {
        return CCQuizViewModel(entry: quiz)
    }
    
    
}


