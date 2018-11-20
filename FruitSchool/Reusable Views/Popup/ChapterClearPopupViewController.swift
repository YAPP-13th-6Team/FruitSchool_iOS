//
//  ChapterFinishPopupViewController.swift
//  FruitSchool
//
//  Created by Presto on 21/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class ChapterClearPopupViewController: UIViewController {

    var grade: Int!
    
    @IBOutlet private weak var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = 15
            backgroundView.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = """
            축하합니다!
            \(Grade(rawValue: grade)?.expression ?? "") 등급의 모든 문제를
            풀었습니다.
            """
        }
    }
    
    @IBOutlet private weak var confirmButton: UIButton! {
        didSet {
            confirmButton.layer.cornerRadius = 15
            confirmButton.addTarget(self, action: #selector(touchUpConfirmButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: ChapterClearImage.allCases[grade].rawValue)
        }
    }
    
    @objc private func touchUpConfirmButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
