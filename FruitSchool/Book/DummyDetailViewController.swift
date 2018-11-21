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
        splitViewController?.delegate = self
    }
}

extension DummyDetailViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
