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
    var isYesOrNo: Bool = false
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
    
    subscript(_ index: Int) -> UIButton {
        if index > 4 {
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
        delegate?.didTouchUpQuizButtons(sender)
    }
}
