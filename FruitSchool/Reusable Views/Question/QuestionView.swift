//
//  QuizView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol QuestionViewDelegate: class {
    func questionButtonsDidTouchUp(_ sender: UIButton)
    func cancelButtonDidTouchUp(_ sender: UIButton)
}

class QuestionView: UIView {
    
    weak var delegate: QuestionViewDelegate?
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(cancelButtonDidTouchUp(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var markImageView: UIImageView! {
        didSet {
            markImageView.image = nil
        }
    }
    
    @IBOutlet var answerButtons: [QuestionButton]! {
        didSet {
            answerButtons.forEach { button in
                button.addTarget(self, action: #selector(questionButtonsDidTouchUp(_:)), for: .touchUpInside)
            }
        }
    }

    // 문제 뷰 버튼에 인덱스로 접근하기 위한 서브스크립트 정의
    subscript(_ index: Int) -> UIButton {
        if !(0...3).contains(index) {
            fatalError("IndexOutOfBoundsException")
        }
        return answerButtons[index]
    }
    
    @objc private func questionButtonsDidTouchUp(_ sender: UIButton) {
        delegate?.questionButtonsDidTouchUp(sender)
    }
    
    @objc private func cancelButtonDidTouchUp(_ sender: UIButton) {
        delegate?.cancelButtonDidTouchUp(sender)
    }
}
