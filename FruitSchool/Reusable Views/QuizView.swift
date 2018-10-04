//
//  QuizView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol QuizViewDelegate: class {
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
    var isChecked: Bool {
        return answer1Button.isSelected || answer2Button.isSelected || answer3Button.isSelected || answer4Button.isSelected
    }
    var answer: String = ""
    var answers: [String] = []
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
    
    func setProperties(_ object: QuizResponse, at item: Int) {
        numberLabel.text = "\(item + 1)."
        titleLabel.text = object.title
        self.answer = object.correctAnswer
        var answers = [String]()
        answers.append(object.correctAnswer)
        for answer in object.incorrectAnswers {
            answers.append(answer)
        }
        answers.shuffle()
        self.answers = answers
        answer1Button.setTitle(answers[0], for: [])
        answer2Button.setTitle(answers[1], for: [])
        answer3Button.setTitle(answers[2], for: [])
        answer4Button.setTitle(answers[3], for: [])
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
