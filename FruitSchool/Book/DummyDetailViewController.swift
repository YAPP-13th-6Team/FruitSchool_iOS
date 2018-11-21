//
//  DummyDetailViewController.swift
//  FruitSchool
//
//  Created by Presto on 21/11/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class DummyDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarButton = UIBarButtonItem()
        backBarButton.title = "교과서"
        navigationItem.backBarButtonItem = backBarButton
    }
}
