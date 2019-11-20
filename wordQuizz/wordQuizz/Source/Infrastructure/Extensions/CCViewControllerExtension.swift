//
//  CCViewControllerExtension.swift
//  wordQuizz
//
//  Created by Raphael Henrique Fontes Sil on 10/11/19.
//  Copyright © 2019 Raphael Henrique Fontes Sil. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func startLoading() {
        let loadingView = CCLoadingView()
        loadingView.show(viewController: self)
    }
    
    func stopLoading(duration: TimeInterval = 0.25) {
        DispatchQueue.main.async {
            if let loadingView = self.view.subviews.first(where: { (view) -> Bool in
                return view is CCLoadingView
            }) as? CCLoadingView {
                loadingView.hide(duration: duration)
            }
        }
    }
    
}
