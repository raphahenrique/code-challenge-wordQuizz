//
//  CCQuizViewController.swift
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
    
    private var bottomViewStartingYPosition = CGFloat(0.0)
    private var initialBottomViewConstraint = CGFloat(0.0)
    
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
        mainView.setupWordTextField(isEnable: false)
        mainView.setupKeyboardNotifications()
        initialBottomViewConstraint = self.mainView.bottomViewBottomConstraint.constant
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
                    stopTimer()
                    print("!!! WIN !!!")
                    //show alert win
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
        mainView.updateTimerLabel(minutes: CCUtils.retrieveMinutesLeft(on: totalSeconds), seconds: CCUtils.retrieveSecondsLeft(on: totalSeconds))
    }
    
    @objc
    private func updateTimer() {
        if totalSeconds != 0 {
            totalSeconds -= kOne
            mainView.updateTimerLabel(minutes: CCUtils.retrieveMinutesLeft(on: totalSeconds), seconds: CCUtils.retrieveSecondsLeft(on: totalSeconds))
        } else {
            stopTimer()
            print("YOU LOST!!")
            // Show alert lost
        }
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
            mainView.setupWordTextField(isEnable: true)
            timer = Timer.scheduledTimer(timeInterval: kOneSecond, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timerIsOn = true
        } else {
            resetQuiz()
        }
        mainView.updateButtonText(isPlaying: timerIsOn)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.mainView.bottomViewBottomConstraint.constant == initialBottomViewConstraint {
                self.mainView.bottomViewBottomConstraint.constant += keyboardSize.height
                self.mainView.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if self.mainView.bottomViewBottomConstraint.constant != initialBottomViewConstraint {
            self.mainView.bottomViewBottomConstraint.constant = initialBottomViewConstraint
            self.mainView.layoutIfNeeded()
        }
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

extension CCQuizViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
