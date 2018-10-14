//
//  QuizView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol QuestionViewDelegate: class {
    func didTouchUpQuizButtons(_ sender: UIButton)
    func didTouchUpCancelButton(_ sender: UIButton)
}

class QuestionView: UIView {
    
    weak var delegate: QuestionViewDelegate?
    var buttons: [UIButton] {
        return [answer1Button, answer2Button, answer3Button, answer4Button]
    }
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var answer1Button: QuestionButton!
    @IBOutlet weak var answer2Button: QuestionButton!
    @IBOutlet weak var answer3Button: QuestionButton!
    @IBOutlet weak var answer4Button: QuestionButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelButton.addTarget(self, action: #selector(didTouchUpCancelButton(_:)), for: .touchUpInside)
        buttons.forEach { button in
            button.addTarget(self, action: #selector(didTouchUpQuizButtons(_:)), for: .touchUpInside)
        }
    }
    // 문제 뷰 버튼에 인덱스로 접근하기 위한 서브스크립트 정의
    subscript(_ index: Int) -> UIButton {
        if !(0...3).contains(index) {
            fatalError("IndexOutOfBoundsException")
        }
        switch index {
        case 0:
            return answer1Button
        case 1:
            return answer2Button
        case 2:
            return answer3Button
        case 3:
            return answer4Button
        default:
            return UIButton()
        }
    }
    
    @objc func didTouchUpQuizButtons(_ sender: UIButton) {
        delegate?.didTouchUpQuizButtons(sender)
    }
    
    @objc func didTouchUpCancelButton(_ sender: UIButton) {
        delegate?.didTouchUpCancelButton(sender)
    }
}
