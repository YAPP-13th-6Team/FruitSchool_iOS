//
//  ChapterFinishPopupViewController.swift
//  FruitSchool
//
//  Created by Presto on 21/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class ChapterFinishPopupViewController: UIViewController {

    var grade: Int!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func confirmButtonDidTouchUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        confirmButton.layer.cornerRadius = 15
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTouchUp(_:)), for: .touchUpInside)
    }
}
