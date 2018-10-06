//
//  PromotionReviewViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 22..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class PromotionReviewViewController: UIViewController {

    var answers: [String] = [] {
        didSet {
            let filtered = answers.filter { !$0.isEmpty }
            if filtered.count == quizsCount {
                executeScoring()
            }
        }
    }
    var grade: Int = 0
    let cellIdentifier = "promotionReviewCell"
    var quizResponse: [QuizResponse]?
    var quizs: [Quiz] = []
    var quizsCount: Int {
        return quizs.count
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "승급 심사"
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestExam(by: grade) { [weak self] response, statusCode, error in
            guard let `self` = self else { return }
            IndicatorView.shared.hideIndicator()
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription, handler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                return
            }
            guard let response = response else { return }
            
            for data in response.data {
                let quiz = Quiz(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.quizs.append(quiz)
                print(data.correctAnswer)
            }
            self.answers = Array.init(repeating: "", count: self.quizs.count)
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.navigationItem.title = "\(Grade(rawValue: self.grade)?.expression ?? "") 승급 심사"
                self.collectionView.reloadData()
            }
        }
    }
}
// MARK: - 채점 로직
extension PromotionReviewViewController {
    private func executeScoring() {
        var score = 0
        guard let alertView = UIView.instantiateFromXib(xibName: "AlertView") as? AlertView else { return }
        alertView.titleLabel.text = "승급 심사"
        alertView.messageLabel.text = "제출?"
        alertView.positiveHandler = { [weak self] in
            guard let `self` = self else { return }
            for index in 0..<self.quizsCount {
                let quiz = self.quizs[index]
                let answer = self.answers[index]
                if quiz.correctAnswer == answer {
                    score += 1
                }
            }
            guard let resultView = UIView.instantiateFromXib(xibName: "ResultView") as? ResultView else { return }
            resultView.frame = self.view.bounds
            resultView.titleLabel.text = "결과"
            let message = "\(score) / \(self.quizsCount)"
            if score == self.quizsCount {
                resultView.descriptionLabel.text = message + "\n통과"
                resultView.handler = {
                    // 사용자 등급 올리기
                    let userGrade = UserDefaults.standard.integer(forKey: "grade")
                    if userGrade != 2 {
                        UserDefaults.standard.set(userGrade + 1, forKey: "grade")
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                resultView.descriptionLabel.text = message + "\n불통"
                resultView.handler = {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.view.addSubview(resultView)
        }
        alertView.frame = view.bounds
        view.addSubview(alertView)
    }
}

extension PromotionReviewViewController: QuizViewDelegate {
    func didTouchUpQuizButtons(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview?.superview as? PromotionReviewCell else { return }
        guard let item = collectionView.indexPath(for: cell)?.item else { return }
        guard let quizView = cell.quizView else { return }
        guard let title = sender.titleLabel?.text else { return }
        self.answers[item] = title
        if let selectedIndex = quizs[item].answers.index(of: title) {
            quizView[selectedIndex].isSelected = true
        }
    }
}

extension PromotionReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PromotionReviewCell else { return UICollectionViewCell() }
        guard let quizView = cell.quizView else { return UICollectionViewCell() }
        quizView.delegate = self
        let quiz = quizs[indexPath.item]
        
        for index in 0..<4 {
            quizView[index].isSelected = false
        }
        let answer = self.answers[indexPath.item]
        let answers = quiz.answers
        if let selectedIndex = answers.index(of: answer) {
            quizView[selectedIndex].isSelected = true
        }
        quizView.numberLabel.text = "\(indexPath.item + 1)"
        quizView.titleLabel.text = quiz.title
        for index in 0..<4 {
            quizView[index].setTitle(quiz.answers[index], for: [])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizs.count
    }
}

extension PromotionReviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell as? PromotionReviewCell else { return }
//        guard let quizView = cell.quizView else { return }
//        if !quizView.selectedAnswer.isEmpty {
//            guard let selectedIndex = quizView.answers.index(of: quizView.selectedAnswer) else { return }
//            quizView[selectedIndex].isSelected = true
//        }
//    }
}

extension PromotionReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
