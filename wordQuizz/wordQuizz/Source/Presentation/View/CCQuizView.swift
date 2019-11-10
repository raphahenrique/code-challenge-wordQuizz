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
}

class CCQuizView: UIView {
    
    // MARK: - Delegate
    
    weak var delegate: CCQuizViewDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var wordTextField: UITextField! {
        didSet {
            
        }
    }
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var amountRightLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startResetButton: UIButton! {
        didSet {
            
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
    }
    
    func clearTextField() {
        wordTextField.text = String()
    }
    
}
