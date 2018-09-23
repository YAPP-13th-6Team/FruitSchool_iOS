//
//  Tutorial4ViewController.swift
//  UIPageViewControllerTest2
//
//  Created by Kim DongHwan on 2018. 9. 23..
//  Copyright © 2018년 Kim DongHwan. All rights reserved.
//

import UIKit

class Tutorial4ViewController: UIViewController, CertificateViewDelegate {

    lazy var certificateView: UIView = {
        let dummy = UIView()
        guard let certificateView = UIView.instantiateFromXib(xibName: "CertificateView") as? CertificateView else { return dummy }
        certificateView.delegate = self
        return certificateView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        certificateView.layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(certificateView)
    }
    
    func didTouchUpButton(_ sender: UIButton) {
        let ud = UserDefaults.standard
        ud.set(true, forKey: "TUTORIAL")
        ud.synchronize()
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
