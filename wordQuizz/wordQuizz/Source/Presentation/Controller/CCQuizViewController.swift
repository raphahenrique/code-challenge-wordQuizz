//
//  ViewController.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 08/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

class CCQuizViewController: UIViewController {

    var mainView: CCQuizView {
        guard let mainView = self.view as? CCQuizView else { fatalError() }
        return mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

