//
//  IndicatorView.swift
//  FruitSchool
//
//  Created by Presto on 05/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class IndicatorView: UIView {

    static let shared = UIView.instantiateFromXib(xibName: "IndicatorView") as? IndicatorView ?? IndicatorView()
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
    }
    
    func showIndicator(to view: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.frame = view.bounds
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.activityIndicatorView.startAnimating()
            view.addSubview(self)
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicatorView.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
