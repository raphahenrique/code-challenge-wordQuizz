//
//  ViewController.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

class CCQuizViewController: UIViewController {

    // MARK: - Properties
    
    var mainView: CCQuizView {
        guard let mainView = self.view as? CCQuizView else { fatalError() }
        return mainView
    }
    private lazy var manager = CCQuizManager(delegate: self)
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchQuiz()
    }
    
    // MARK: - Functions
    
    private func fetchQuiz() {
        manager.fetchWordQuiz()
    }
    
    
}

extension CCQuizViewController: CCQuizManagerDelegate {
    func didFetchQuiz(_ quiz: CCQuizModel) {
        print(quiz.question)
    }
    
    func errorToFetch(_ error: CCError) {
        print(error.errorType)
    }
}
