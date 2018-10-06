//
//  ExerciseViewController.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    var answers: [String] = [] {
        didSet {
            let filtered = answers.filter { !$0.isEmpty }
            if filtered.count == quizsCount {
                executeScoring()
            }
        }
    }
    var id: String = ""
    let cellIdentifier = "exerciseCell"
    var quizs: [Quiz] = []
    var quizsCount: Int {
        return quizs.count
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo_noncircle")))
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
            for data in response.data.quizs {
                let quiz = Quiz(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.quizs.append(quiz)
            }
            self.answers = Array.init(repeating: "", count: self.quizs.count)
            DispatchQueue.main.async { [weak self] in
                self?.navigationItem.title = response.data.title + " 문제 풀이"
                self?.collectionView.reloadData()
            }
        }
    }
}
// MARK: - 채점 로직
extension ExerciseViewController {
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
            if score == self.quizsCount {
                resultView.descriptionLabel.text = "통과"
                resultView.handler = {
                    guard let record = ChapterRecord.fetch().filter("id = %@", self.id).first else { return }
                    ChapterRecord.update(record, keyValue: ["isPassed": true])
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

extension ExerciseViewController: QuizViewDelegate {
    func didTouchUpQuizButtons(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview?.superview as? ExerciseCell else { return }
        guard let item = collectionView.indexPath(for: cell)?.item else { return }
        guard let quizView = cell.quizView else { return }
        guard let title = sender.titleLabel?.text else { return }
        self.answers[item] = title
        if let selectedIndex = quizs[item].answers.index(of: title) {
            quizView[selectedIndex].isSelected = true
        }
    }
}

extension ExerciseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ExerciseCell else { return UICollectionViewCell() }
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
