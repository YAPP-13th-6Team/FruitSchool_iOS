//
//  ExerciseViewController.swift
//  FruitSchool
//
//  Created by Presto on 12/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

//protocol ExerciseDelegate: class {
//    func didDismissExerciseViewController(_ fruitTitle: String)
//}

class ExerciseViewController: BaseContainerViewController {

    weak var delegate: ExerciseDelegate?
    var id: String = ""
    var fruitTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeExercises()
    }
}

extension ExerciseViewController: Exercisable {
    func executeScoring() {
        var score = 0
        UIAlertController
            .alert(title: "", message: "제출할까요?")
            .action(title: "확인", style: .default) { _ in
                for index in 0..<self.quizsCount {
                    let quiz = self.quizs[index]
                    let answer = self.answers[index]
                    if quiz.correctAnswer == answer {
                        score += 1
                    }
                }
                if score == self.quizsCount {
                    UIAlertController
                        .alert(title: "결과", message: "통과")
                        .action(title: "확인", handler: { _ in
                            guard let record = ChapterRecord.fetch().filter("id = %@", self.id).first else { return }
                            ChapterRecord.update(record, keyValue: ["isPassed": true])
                            self.dismiss(animated: true, completion: {
                                self.delegate?.didDismissExerciseViewController(self.fruitTitle)
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
        IndicatorView.shared.showIndicator()
        API.requestExercises(by: id) { response, _, error in
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
            for data in response.data.quizs {
                let quiz = Question(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.quizs.append(quiz)
                print(quiz.answers, quiz.correctAnswer)
            }
            self.answers = Array(repeating: "", count: self.quizs.count)
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
