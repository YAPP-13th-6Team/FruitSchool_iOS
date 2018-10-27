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
    let imageNames = ["dog_clear", "student_clear", "boss_clear"]
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
        titleLabel.text = """
        축하합니다!
        \(Grade(rawValue: grade)?.expression ?? "") 등급의 모든 문제를
        풀었습니다.
        """
        imageView.image = UIImage(named: imageNames[grade])
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        confirmButton.layer.cornerRadius = 15
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTouchUp(_:)), for: .touchUpInside)
    }
}
