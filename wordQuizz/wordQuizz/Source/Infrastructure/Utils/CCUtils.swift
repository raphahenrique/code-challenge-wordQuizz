//
//  CCUtils.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 10/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

class CCUtils {
    
    static func retrieveMinutesLeft(on totalSeconds: Int) -> Int {
        return Int(totalSeconds) / 60 % 60
    }
    
    static func retrieveSecondsLeft(on totalSeconds: Int) -> Int {
        return Int(totalSeconds) % 60
    }
    
}

extension UIView {
    
    func roundView(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
}

extension UITextField {
    
    func setLeftPadding(by: CGFloat){
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: by, height: self.frame.size.height))
        self.leftView = padding
        self.leftViewMode = .always
    }
    
}
