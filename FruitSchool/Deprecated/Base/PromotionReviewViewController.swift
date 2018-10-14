//
//  PromotionReviewViewController.swift
//  FruitSchool
//
//  Created by Presto on 12/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

//protocol PromotionReviewDelegate: class {
//    func didDismissPromotionReviewViewController(_ grade: Int)
//}

class PromotionReviewViewController: BaseContainerViewController {

    weak var delegate: PromotionReviewDelegate?
    var grade: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeExercises()
    }
}

extension PromotionReviewViewController: Exercisable {
    func executeScoring() {
        var score = 0
        UIAlertController
            .alert(title: "승급 심사", message: "제출할까요?")
            .action(title: "확인") { _ in
                for index in 0..<self.quizsCount {
                    let quiz = self.quizs[index]
                    let answer = self.answers[index]
                    if quiz.correctAnswer == answer {
                        score += 1
                    }
                }
                let percent = Double(score) / Double(self.quizsCount)
                if percent > 0.7 {
                    UIAlertController
                        .alert(title: "결과", message: "통과")
                        .action(title: "확인", handler: { _ in
                            guard let userRecord = UserRecord.fetch().first else { return }
                            let myGrade = userRecord.grade
                            if myGrade != 2 {
                                UserRecord.update(userRecord, keyValue: ["grade": myGrade + 1])
                                IndicatorView.shared.showIndicator(message: "Loading...")
                                API.requestGradeUp(myGrade, completion: { _, _, error in
                                    if let error = error {
                                        UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                                        return
                                    }
                                })
                            }
                            switch self.grade {
                            case 0:
                                UserRecord.update(userRecord, keyValue: ["passesDog": true])
                            case 1:
                                UserRecord.update(userRecord, keyValue: ["passesStudent": true])
                            case 2:
                                UserRecord.update(userRecord, keyValue: ["passesBoss": true])
                            default:
                                break
                            }
                            self.dismiss(animated: true, completion: {
                                self.delegate?.didDismissPromotionReviewViewController(self.grade)
                            })
                        })
                        .present(to: self)
                } else {
                    UIAlertController
                        .alert(title: "결과", message: "불통")
                        .action(title: "확인", handler: { _ in
                            self.dismiss(animated: true, completion: nil)
                        })
                        .present(to: self)
                }
            }
            .action(title: "취소", style: .cancel)
            .present(to: self)
    }
    
    func makeExercises() {
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestExam(by: grade) { response, _, error in
            IndicatorView.shared.hideIndicator()
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription, handler: {
                        self?.dismiss(animated: true, completion: nil)
                    })
                }
                return
            }
            guard let response = response else { return }
            for data in response.data {
                let quiz = Question(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.quizs.append(quiz)
                print(quiz.answers, quiz.correctAnswer)
            }
            self.answers = Array(repeating: "", count: self.quizsCount)
            DispatchQueue.main.async {
                self.setup()
                self.containerView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.containerView.transform = CGAffineTransform.identity
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.pageControl.alpha = 1
                    })
                })
            }
        }
    }
}
