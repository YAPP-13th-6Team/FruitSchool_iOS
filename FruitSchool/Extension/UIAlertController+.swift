//
//  UIAlertController+.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 4..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func alert(_ style: UIAlertControllerStyle = .alert, title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        return alert
    }
    
    @discardableResult
    func action(_ style: UIAlertActionStyle = .default, title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style) { (action) in
            handler?(action)
        }
        self.addAction(action)
        return self
    }
    
    func present(to viewController: UIViewController?, handler: (() -> Void)? = nil) {
        viewController?.present(self, animated: true, completion: handler)
    }
}

extension UIAlertController {
    static func presentErrorAlert(to viewController: UIViewController?, error: String, handler: (() -> Void)? = nil) {
        UIAlertController
            .alert(title: "", message: error)
            .action(title: "확인") { _ in
                handler?()
            }
            .present(to: viewController)
    }
}
