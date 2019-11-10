//
//  CCLoadingView.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 10/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

class CCLoadingView: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func show(viewController: UIViewController) {

        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.42)
        self.alpha = 1
        
        self.removeFromSuperview()
        
        viewController.view.addSubview(self)
        viewController.view.bringSubviewToFront(self)
        
        fillSuperview()
        
        activityIndicator.color = UIColor.white
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        self.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        self.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hide(animated: Bool = true, duration: TimeInterval = 0.25, completion: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            UIView.animate(withDuration: duration, animations: {
                self?.alpha = 0
            }, completion: { (_) in
                self?.removeFromSuperview()
                if let completion = completion {
                    completion()
                }
            })
            
        }
    }
    
    private func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
}
