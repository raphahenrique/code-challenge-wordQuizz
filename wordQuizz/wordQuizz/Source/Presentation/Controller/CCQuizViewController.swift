//
//  ViewController.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

class CCQuizViewController: UIViewController, CCQuizViewDelegate, CCQuizManagerDelegate {

    // MARK: - Constants
    
    let kZero = 0
    
    // MARK: - Properties
    
    var mainView: CCQuizView {
        guard let mainView = self.view as? CCQuizView else { fatalError() }
        return mainView
    }
    private lazy var manager = CCQuizManager(delegate: self)
    private var wordsLeft: [String]?
    private var totalWords = 0
    
    private var correctWords = [String]()
    // private var correctCount = 0
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        fetchQuiz()
    }
    
    // MARK: - Functions
    
    private func setup() {
        mainView.delegate = self
        mainView.wordTextField.delegate = self
        mainView.wordTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        mainView.wordsTableView.delegate = self
        mainView.wordsTableView.dataSource = self
    }
    
    private func fetchQuiz() {
        manager.fetchWordQuiz()
    }
    
    @objc
    private func textDidChange(_ textField: UITextField) {
        if let currentWord = textField.text {
            if isMatch(currentWord) {
                if let wordsLeftCount = wordsLeft?.count {
                    correctWords.append(currentWord)
                    addAnswerToTableView()
                    clearTextField()
                    if correctWords.count == totalWords {
                        print("WIN !!!")
                    }
                }
            }
        }
    }
    
    private func isMatch(_ word: String) -> Bool {
        let currentWord = word.lowercased()
        if let allWords = wordsLeft {
            if allWords.contains(currentWord) {
                print("WORD FOUND !!")
                return true
            }
        }
        return false
    }
    
    private func addAnswerToTableView() {
        let indexPath = IndexPath(row: correctWords.count - 1, section: 0)
        mainView.addAnswerToTableViewAt(indexPath: indexPath)
    }
    
    private func clearTextField() {
        mainView.clearTextField()
    }
    
    // MARK: - View Delegate
    
    func startResetButtonTapped() {
        print("start tapped")
    }
    
    // MARK: - Manager Delegate
    
    func didFetchQuiz(_ quiz: CCQuizViewModel) {
        wordsLeft = quiz.answers
        totalWords = wordsLeft?.count ?? kZero
        DispatchQueue.main.async {
            self.mainView.setupQuestion(question: quiz.question)
        }
    }
    
    func errorToFetch(_ error: CCError) {
        print(error.errorType)
    }
    
}

extension CCQuizViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CCQuizViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return correctWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = correctWords[indexPath.row]
        return cell
    }
    
    
}
