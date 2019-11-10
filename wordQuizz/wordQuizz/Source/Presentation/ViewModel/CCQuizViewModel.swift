//
//  CCQuizViewModel.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 09/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import Foundation

struct CCQuizViewModel {
    
    private let entry: CCQuizModel
    
    init(entry: CCQuizModel) {
        self.entry = entry
    }
    
    var question: String {
        return self.entry.question
    }
    var answers: [String] {
        let lowercasedAnswers = self.entry.answers.map { (answer) -> String in
            return answer.lowercased()
        }
        return lowercasedAnswers
    }
    
    
}
