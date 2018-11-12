////
////  ExerciseViewController.swift
////  FruitSchool
////
////  Created by Presto on 30/10/2018.
////  Copyright © 2018 YAPP. All rights reserved.
////
//
//import UIKit
//
//protocol ExerciseDelegate: class {
//    func didDismissExerciseViewController(_ fruitTitle: String)
//}
//
//class ExerciseViewController: UIViewController {
//
//    var timer: Timer!
//    var answers: [String] = []
//    var id: String = ""
//    var fruitTitle: String = ""
//    var currentIndex: Int = 0
//    var questions: [Question] = []
//    var correctCountBarButtonItem: UIBarButtonItem!
//    @IBOutlet weak var contentView: UIView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        timer = Timer(timeInterval: 5, target: self, selector: #selector(countDown(_:)), userInfo: nil, repeats: false)
//        setUpNavigationItems()
//    }
//
//    func setUpNavigationItems() {
//        navigationItem.hidesBackButton = true
//        let backButton = UIBarButtonItem(title: "카드", style: .plain, target: self, action: #selector(backButtonDidTouchUp(_:)))
//        navigationItem.leftBarButtonItem = backButton
//        correctCountBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
//        navigationItem.rightBarButtonItem = correctCountBarButtonItem
//    }
//
//    func makeQuestions() {
//        IndicatorView.shared.showIndicator()
//        API.requestExercises(by: id) { response, _, error in
//            IndicatorView.shared.hideIndicator()
//            if let error = error {
//                DispatchQueue.main.async { [weak self] in
//                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription, handler: {
//                        self?.dismiss(animated: true, completion: nil)
//                    })
//                }
//                return
//            }
//            guard let response = response else { return }
//            // 서버에서 받은 데이터를 클라이언트에서 사용하기 좋게 주무르기
//            for data in response.data.quizs {
//                let question = Question(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
//                self.questions.append(question)
//            }
//            // 정답이 기록될 전역 프로퍼티 배열 초기화
//            self.answers = Array(repeating: "", count: self.questions.count)
//            DispatchQueue.main.async {
//                self.setUpQuestionView()
//            }
//        }
//    }
//
//    func setUpQuestionView() {
//        guard let questionView = UIView.instantiateFromXib(xibName: "QuestionView") as? QuestionView else { return }
//        questionView.delegate = self
//        questionView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(questionView)
//        NSLayoutConstraint.activate([
//            questionView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            questionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            questionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            questionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//            ])
//        let question = questions[currentIndex]
//        let attributedString = NSMutableAttributedString(string: question.title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .ultraLight)])
//        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .medium)]
//        let range = (question.title as NSString).range(of: fruitTitle)
//        attributedString.addAttributes(boldFontAttribute, range: range)
//        questionView.titleLabel.attributedText = attributedString
//        for buttonIndex in 0..<4 {
//            questionView[buttonIndex].setTitle(question.answers[buttonIndex], for: [])
//        }
//    }
//
//    @objc func countDown(_ timer: Timer) {
//
//    }
//
//    @objc func backButtonDidTouchUp(_ sender: UIBarButtonItem) {
//
//    }
//}
//
//extension ExerciseViewController: QuestionViewDelegate {
//    func questionButtonsDidTouchUp(_ sender: UIButton) {
//
//    }
//}
