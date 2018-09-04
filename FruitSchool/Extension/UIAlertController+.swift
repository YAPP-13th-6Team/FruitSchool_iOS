//
//  UIAlertController+.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 4..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func alert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alert
    }
    
    static func actionSheet(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        return alert
    }
    
    @discardableResult
    func defaultAction(title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: .default) { (action) in
            handler?(action)
        }
        self.addAction(action)
        return self
    }
    
    @discardableResult
    func destructiveAction(title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: .destructive) { (action) in
            handler?(action)
        }
        self.addAction(action)
        return self
    }
    
    @discardableResult
    func cancelAction(title: String?, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let action = UIAlertAction(title: title, style: .cancel) { (action) in
            handler?(action)
        }
        self.addAction(action)
        return self
    }
    
    func present(to viewController: UIViewController?, handler: (() -> Void)? = nil) {
        viewController?.present(self, animated: true, completion: handler)
    }
}
