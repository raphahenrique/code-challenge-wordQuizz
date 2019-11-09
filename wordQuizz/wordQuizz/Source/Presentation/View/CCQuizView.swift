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
    
}
