//
//  CCQuizModel.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import Foundation

struct CCQuizModel: Decodable {
    var question: String
    var answers: [String]
    
    private enum CodingKeys: String, CodingKey {
        case question
        case answers = "answer"
    }
}
