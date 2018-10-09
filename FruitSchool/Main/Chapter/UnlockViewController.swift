//
//  UnlockViewController.swift
//  FruitSchool
//
//  Created by Presto on 09/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class UnlockViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setup() {
        backgroundView.layer.cornerRadius = 15
        backgroundView.layer.masksToBounds = true
    }
}
