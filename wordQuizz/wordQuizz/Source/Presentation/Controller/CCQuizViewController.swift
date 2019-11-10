//
//  ViewController.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

class CCQuizViewController: UIViewController {

    // MARK: - Constants
    
    private let kZero = 0
    private let kOne = 1
    private let kOneSecond = 1.0
    
    // MARK: - Properties
    
    var mainView: CCQuizView {
        guard let mainView = self.view as? CCQuizView else { fatalError() }
        return mainView
    }
    private lazy var manager = CCQuizManager(delegate: self)
    private var wordsLeft: [String]?
    private var totalWords = 0
    private var correctWords = [String]()
    
    private var timer = Timer()
    private var totalSeconds = 30
    private var timerIsOn = false
    
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
        mainView.updateButtonText(isPlaying: timerIsOn)
    }
    
    private func fetchQuiz() {
        // start loading
        manager.fetchWordQuiz()
    }
    
    @objc
    private func textDidChange(_ textField: UITextField) {
        if let currentWord = textField.text {
            if isMatch(currentWord) {
                correctWords.append(currentWord)
                wordsLeft = wordsLeft?.filter{ $0 != currentWord }
                addAnswerToTableView()
                updateCount()
                clearTextField()
                if correctWords.count == totalWords {
                    print("!!! WIN !!!")
                    stopTimer()
                }
            }
        }
    }
    
    private func isMatch(_ word: String) -> Bool {
        let currentWord = word.lowercased()
        if let allWords = wordsLeft {
            if allWords.contains(currentWord) {
                return true
            }
        }
        return false
    }
    
    private func addAnswerToTableView() {
        let indexPath = IndexPath(row: correctWords.count - kOne, section: kZero)
        mainView.addAnswerToTableViewAt(indexPath: indexPath)
    }
    
    private func updateCount() {
        mainView.updateAmountRight(currentAmount: correctWords.count, totalAmount: totalWords)
    }
    
    private func clearTextField() {
        mainView.clearTextField()
    }
    
    private func setupAmountAndTimer() {
        mainView.updateAmountRight(currentAmount: correctWords.count, totalAmount: totalWords)
        mainView.updateTimerLabel(minutes: retrieveMinutesLeft(), seconds: retrieveSecondsLeft())
    }
    
    @objc
    private func updateTimer() {
        if totalSeconds != 0 {
            totalSeconds -= kOne
            mainView.updateTimerLabel(minutes: retrieveMinutesLeft(), seconds: retrieveSecondsLeft())
        } else {
            stopTimer()
            print("YOU LOST!!")
        }
    }
    
    private func retrieveMinutesLeft() -> Int {
        return Int(totalSeconds) / 60 % 60
    }
    
    private func retrieveSecondsLeft() -> Int {
        return Int(totalSeconds) % 60
    }
    
    private func stopTimer() {
        timer.invalidate()
        timerIsOn = false
    }
    
    private func resetQuiz() {
        totalSeconds = 30
        timer.fire()
        //clearTableView, textField and words arrays, fetch again ?
    }
    
}

extension CCQuizViewController: CCQuizViewDelegate, CCQuizManagerDelegate {
    
    // MARK: - View Delegate
    
    func startResetButtonTapped() {
        if !timerIsOn {
            timer = Timer.scheduledTimer(timeInterval: kOneSecond, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timerIsOn = true
        } else {
            resetQuiz()
        }
        mainView.updateButtonText(isPlaying: timerIsOn)
    }
    
    // MARK: - Manager Delegate
    
    func didFetchQuiz(_ quiz: CCQuizViewModel) {
        // stop loading
        wordsLeft = quiz.answers
        totalWords = wordsLeft?.count ?? kZero
        DispatchQueue.main.async {
            self.mainView.setupQuestion(question: quiz.question)
        }
        setupAmountAndTimer()
    }
    
    func errorToFetch(_ error: CCError) {
        // stop loading
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
