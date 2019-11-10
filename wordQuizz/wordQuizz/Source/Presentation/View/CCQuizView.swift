//
//  CCQuizView.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

protocol CCQuizViewDelegate: AnyObject {
    func startResetButtonTapped()
    func keyboardWillShow(_ sender: Notification)
    func keyboardWillHide(_ sender: Notification)
}

class CCQuizView: UIView {
    
    // MARK: - Delegate
    
    weak var delegate: CCQuizViewDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField! {
        didSet {
            wordTextField.placeholder = "Insert Word"
            wordTextField.roundView(radius: 4.0)
            wordTextField.setLeftPadding(by: 10.0)
        }
    }
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountRightLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton! {
        didSet {
            startResetButton.roundView(radius: 8.0)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func startResetTapped(_ sender: Any) {
        delegate?.startResetButtonTapped()
    }
    
    // MARK: - Functions
    
    func setupQuestion(question: String) {
        quizTitleLabel.text = question
    }
    
    func addAnswerToTableViewAt(indexPath: IndexPath) {
        wordsTableView.insertRows(at: [indexPath], with: .automatic)
        wordsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func updateAmountRight(currentAmount: Int, totalAmount: Int) {
        DispatchQueue.main.async {
            self.amountRightLabel.text = "\(String(format: "%02d", currentAmount))/\(totalAmount)"
        }
    }
    
    func clearTextField() {
        wordTextField.text = String()
    }
    
    func updateTimerLabel(minutes: Int, seconds: Int) {
        DispatchQueue.main.async {
            self.timerLabel.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        }
    }
    
    func updateButtonText(isPlaying: Bool) {
        if isPlaying {
            startResetButton.setTitle("Reset", for: .normal)
        } else {
            startResetButton.setTitle("Start", for: .normal)
        }
    }
    
    func setupWordTextField(isEnable: Bool) {
        wordTextField.isEnabled = isEnable
    }
    
    // MARK: - Keyboard Subscribers
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func keyboardNotification(_ sender: Notification) {
        self.delegate?.keyboardWillShow(sender)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.delegate?.keyboardWillShow(sender)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.delegate?.keyboardWillHide(sender)
    }
    
    func constraintAdjustForKeyboard(_ keyboardHeight: CGFloat) -> CGFloat {
        let parentHeight = self.frame.size.height
        let bottomPos = bottomView.frame.size.height + bottomView.frame.origin.y
        return CGFloat(abs((parentHeight - keyboardHeight) - (bottomPos)))
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
}
