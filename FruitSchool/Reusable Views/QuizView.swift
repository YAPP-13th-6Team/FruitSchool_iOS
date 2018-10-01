//
//  QuizView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol QuizViewDelegate: class {
    var title: String { get }
    var answers: [String] { get }
    var number: Int { get }
    var answerIndex: Int { get }
    func didTouchUpQuizButtons(_ sender: UIButton)
}

class QuizView: UIView {
    
    weak var delegate: QuizViewDelegate?
    var firstLineStackView: UIStackView! {
        return stackView.arrangedSubviews.first as? UIStackView
    }
    var secondLineStackView: UIStackView! {
        return stackView.arrangedSubviews.last as? UIStackView
    }
    var answer1Button: UIButton! {
        return firstLineStackView.arrangedSubviews.first as? UIButton
    }
    var answer2Button: UIButton! {
        return firstLineStackView.arrangedSubviews.last as? UIButton
    }
    var answer3Button: UIButton! {
        return secondLineStackView.arrangedSubviews.first as? UIButton
    }
    var answer4Button: UIButton! {
        return secondLineStackView.arrangedSubviews.last as? UIButton
    }
    var buttons: [UIButton] {
        return [answer1Button, answer2Button, answer3Button, answer4Button]
    }
    var isYesOrNo: Bool = false
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.text = "\(delegate?.number ?? 0)"
        titleLabel.text = delegate?.title
        answer1Button.setTitle(delegate?.answers[0], for: [])
        answer2Button.setTitle(delegate?.answers[1], for: [])
        answer3Button.setTitle(delegate?.answers[2], for: [])
        answer4Button.setTitle(delegate?.answers[3], for: [])
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
    
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
    
    @IBAction func didTouchUpQuizButtons(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        delegate?.didTouchUpQuizButtons(sender)
    }
}
