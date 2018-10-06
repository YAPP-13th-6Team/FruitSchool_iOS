//
//  PromotionReviewViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 22..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class PromotionReviewViewController: UIViewController {

    var grade: Int = 0
    let cellIdentifier = "promotionReviewCell"
    var quizs: [QuizResponse]?
    var quizsCount: Int {
        return quizs?.count ?? 0
    }
    var selectedCount: Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "승급 심사"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestExam(by: grade) { response, statusCode, error in
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
            self.quizs = response.data
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.navigationItem.title = "\(Grade(rawValue: self.grade)?.rawValue ?? 0) 승급 심사"
                self.collectionView.reloadData()
            }
        }
    }
}
// MARK: - 채점 로직
extension PromotionReviewViewController {
    private func executeScoring() {
        var checkedQuizCount = 0
        for index in 0..<quizsCount {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PromotionReviewCell else { return }
            if cell.quizView.isChecked {
                checkedQuizCount += 1
            }
        }
        if checkedQuizCount == quizsCount {
            var score = 0
            guard let alertView = UIView.instantiateFromXib(xibName: "AlertView") as? AlertView else { return }
            alertView.titleLabel.text = "승급 심사"
            alertView.messageLabel.text = "제출할까요?"
            alertView.positiveHandler = { [weak self] in
                guard let `self` = self else { return }
                for index in 0..<self.quizsCount {
                    guard let cell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ExerciseCell else { return }
                    guard let quizView = cell.quizView else { return }
                    let answer = quizView.answer
                    let answers = quizView.answers
                    for buttonIndex in 0..<4 where answers[buttonIndex] == answer {
                        let button = quizView[buttonIndex]
                        if button.isSelected {
                            score += 1
                            break
                        }
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
                        UserDefaults.standard.set(userGrade + 1, forKey: "grade")
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
}

extension PromotionReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PromotionReviewCell else { return UICollectionViewCell() }
        let quiz = quizs?[indexPath.item]
        cell.setProperties(quiz, at: indexPath.item, handler: executeScoring)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizs?.count ?? 0
    }
}

extension PromotionReviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
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
