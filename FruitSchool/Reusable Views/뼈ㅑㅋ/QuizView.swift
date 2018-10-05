//
//  QuizView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class QuizView: UIView {
    
    var buttons: [UIButton] {
        return [answer1Button, answer2Button, answer3Button, answer4Button]
    }
    var isChecked: Bool {
        return answer1Button.isSelected || answer2Button.isSelected || answer3Button.isSelected || answer4Button.isSelected
    }
    var answer: String = ""
    var answers: [String] = []
    var handler: (() -> Void)?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answer1Button: QuizButton!
    @IBOutlet weak var answer2Button: QuizButton!
    @IBOutlet weak var answer3Button: QuizButton!
    @IBOutlet weak var answer4Button: QuizButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
    
    func setProperties(_ object: QuizResponse, at item: Int) {
        numberLabel.text = "\(item + 1)."
        titleLabel.text = object.title
        var answers = [[object.correctAnswer], object.incorrectAnswers].flatMap { $0 }
        answers.shuffle()
        self.answers = answers
        self.answer = object.correctAnswer
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
        handler?()
    }
}
