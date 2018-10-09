//
//  ExerciseContainerViewController.swift
//  FruitSchool
//
//  Created by Presto on 08/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

protocol ExerciseDelegate: class {
    func didDismissExerciseViewController(_ fruitTitle: String)
}

class ExerciseContainerViewController: UIViewController {

    weak var delegate: ExerciseDelegate?
    var answers: [String] = [] {
        didSet {
            let filtered = answers.filter { !$0.isEmpty }
            DispatchQueue.main.async {
                if filtered.count == self.quizsCount {
                    UIView.animate(withDuration: 0.2) {
                        self.submitButton.alpha = 1
                        self.checksAllQuiz = true
                    }
                }
            }
        }
    }
    var checksAllQuiz: Bool = false
    var id: String = ""
    var fruitTitle: String = ""
    var quizs: [Quiz] = []
    var quizsCount: Int {
        return quizs.count
    }
    var pageViewController: UIPageViewController!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeExercises()
    }
    
    private func makeExercises() {
        IndicatorView.shared.showIndicator(message: "Loading...")
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
                let quiz = Quiz(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.quizs.append(quiz)
                print(quiz.answers, quiz.correctAnswer)
            }
            self.answers = Array(repeating: "", count: self.quizs.count)
            DispatchQueue.main.async {
                self.setUp()
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
    
    private func setUp() {
        submitButton.addTarget(self, action: #selector(didTouchUpSubmitButton(_:)), for: .touchUpInside)
        submitButton.layer.cornerRadius = 15
        submitButton.backgroundColor = .white
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        submitButton.titleLabel?.minimumScaleFactor = 0.1
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        submitButton.setTitleColor(.black, for: [])
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanContentView(_:))))
        pageControl.numberOfPages = quizs.count
        self.pageViewController = childViewControllers.first as? UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([makeContentViewController(at: 0) ?? UIViewController()], direction: .forward, animated: true, completion: nil)
    }
    
    private func makeContentViewController(at index: Int) -> ExerciseContentViewController? {
        guard let controller = UIViewController.instantiate(storyboard: "Exercise", identifier: ExerciseContentViewController.classNameToString) as? ExerciseContentViewController else { return nil }
        controller.pageIndex = index
        guard let quizView = UIView.instantiateFromXib(xibName: "QuizView") as? QuizView else { return nil }
        let quiz = quizs[index]
        quizView.numberLabel.text = "문제 \(index + 1)"
        let attributedString = NSMutableAttributedString(string: quiz.title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .ultraLight)])
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .medium)]
        let range = (quiz.title as NSString).range(of: fruitTitle)
        attributedString.addAttributes(boldFontAttribute, range: range)
        quizView.titleLabel.attributedText = attributedString
        for buttonIndex in 0..<4 {
            quizView[buttonIndex].setTitle(quiz.answers[buttonIndex], for: [])
        }
        quizView.delegate = self
        controller.quizView = quizView
        return controller
    }
}
// MARK: - Selectors
extension ExerciseContainerViewController {
    @objc func didPanContentView(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.translation(in: view).y
        switch gesture.state {
        case .changed:
            if velocityY >= 0 {
                containerViewCenterYConstraint.constant = velocityY
            }
            if checksAllQuiz {
                UIView.animate(withDuration: 0.1) {
                    self.submitButton.alpha = 0
                }
            }
        case .ended:
            if gesture.velocity(in: view).y > 1000 {
                containerViewCenterYConstraint.constant = view.bounds.height
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                return
            } else {
                if checksAllQuiz {
                    UIView.animate(withDuration: 0.1) {
                        self.submitButton.alpha = 1
                    }
                }
                containerViewCenterYConstraint.constant = 0
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    @objc func didTouchUpSubmitButton(_ sender: UIButton) {
        executeScoring()
    }
}

// MARK: - Scoring Logic
extension ExerciseContainerViewController {
    private func executeScoring() {
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
}
// MARK: - QuizView Custom Delegate Implementation
extension ExerciseContainerViewController: QuizViewDelegate {
    func didTouchUpQuizButtons(_ sender: UIButton) {
        let currentPageIndex = pageControl.currentPage
        guard let quizView = (pageViewController.viewControllers?[currentPageIndex] as? ExerciseContentViewController)?.quizView else { return }
        guard let title = sender.titleLabel?.text else { return }
        self.answers[currentPageIndex] = title
        for index in 0..<4 {
            UIView.animate(withDuration: 0.2) {
                quizView[index].backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            }
        }
        if let selectedIndex = quizs[currentPageIndex].answers.index(of: title) {
            UIView.animate(withDuration: 0.2) {
                quizView[selectedIndex].backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
            }
        }
    }
    
    func didTouchUpCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UIPageViewController DataSource Implementation
extension ExerciseContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? ExerciseContentViewController else { return nil }
        guard let index = controller.pageIndex else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return makeContentViewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? ExerciseContentViewController else { return nil }
        guard let index = controller.pageIndex else { return nil }
        let nextIndex = index + 1
        if nextIndex >= quizs.count {
            return nil
        }
        return makeContentViewController(at: nextIndex)
    }
}
// MARK: - UIPageViewController Delegate Implementation
extension ExerciseContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first as? ExerciseContentViewController else { return }
        pageControl.currentPage = pageContentViewController.pageIndex
    }
}
