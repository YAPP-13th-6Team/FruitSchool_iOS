//
//  ExerciseViewController.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    var id: String = ""
    let cellIdentifier = "exerciseCell"
    var exerciseResponse: ExerciseResponse.Data?
    var fruitTitle: String? {
        return exerciseResponse?.title
    }
    var quizs: [QuizResponse]? {
        return exerciseResponse?.quizs
    }
    var quizsCount: Int {
        return quizs?.count ?? 0
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestExercises(by: id) { response, statusCode, error in
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
            self.exerciseResponse = response.data
            DispatchQueue.main.async { [weak self] in
                guard let fruitTitle = self?.fruitTitle else { return }
                self?.navigationItem.title = fruitTitle + " 문제 풀이"
                self?.collectionView.reloadData()
            }
        }
    }
}
// MARK: - 채점 로직
extension ExerciseViewController {
    private func executeScoring() {
        var checkedQuizCount = 0
        // 각 문제를 풀었는지 검사함
        for index in 0..<quizsCount {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ExerciseCell else { return }
            if cell.quizView.isChecked {
                checkedQuizCount += 1
            }
        }
        if checkedQuizCount == quizsCount {
            // 모든 문제를 풂
            var score = 0
            guard let alertView = UIView.instantiateFromXib(xibName: "AlertView") as? AlertView else { return }
            alertView.titleLabel.text = "문제 풀기"
            alertView.messageLabel.text = "제출할까요?"
            alertView.positiveHandler = { [weak self] in
                // 채점 로직
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
                if score == self.quizsCount {
                    resultView.descriptionLabel.text = "통과"
                    resultView.handler = {
                        guard let record = Record.fetch().filter("id = %@", self.id).first else { return }
                        Record.update(record, keyValue: ["isPassed": true])
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    resultView.descriptionLabel.text = "불통"
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

extension ExerciseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ExerciseCell else { return UICollectionViewCell() }
        let quiz = quizs?[indexPath.item]
        cell.setProperties(quiz, at: indexPath.item, handler: executeScoring)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizs?.count ?? 0
    }
}

extension ExerciseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ExerciseViewController: UICollectionViewDelegateFlowLayout {
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
