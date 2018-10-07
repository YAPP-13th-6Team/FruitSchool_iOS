//
//  PromotionReviewContainerViewController.swift
//  FruitSchool
//
//  Created by Presto on 08/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class PromotionReviewContainerViewController: UIViewController {

    var answers: [String] = [] {
        didSet {
            let filtered = answers.filter { !$0.isEmpty }
            if filtered.count == quizsCount {
                executeScoring()
            }
        }
    }
    var grade: Int = 0
    var quizs: [Quiz] = []
    var quizsCount: Int {
        return quizs.count
    }
    var pageViewController: UIPageViewController!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestExam(by: grade) { response, statusCode, error in
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
                let quiz = Quiz(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.quizs.append(quiz)
            }
            self.answers = Array(repeating: "", count: self.quizs.count)
            DispatchQueue.main.async {
                self.setUp()
            }
        }
    }
    func setUp() {
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanContentView(_:))))
        self.pageViewController = childViewControllers.first as? UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        guard let start = self.viewController(at: 0) else { return }
        let viewControllers = NSArray(object: start)
        pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        pageControl.numberOfPages = quizs.count
    }
    
    @objc func didPanContentView(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.translation(in: view).y
        print(gesture.velocity(in: view).y)
        switch gesture.state {
        case .changed:
            if velocityY >= 0 {
                containerViewCenterYConstraint.constant = velocityY
            }
        case .ended:
            if gesture.velocity(in: view).y > 1000 {
                containerViewCenterYConstraint.constant = view.bounds.height
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
                return
            } else {
                containerViewCenterYConstraint.constant = 0
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    func viewController(at index: Int) -> PromotionReviewContentViewController? {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: PromotionReviewContentViewController.classNameToString) as? PromotionReviewContentViewController else { return nil }
        guard let quizView = controller.quizView else { return nil }
        quizView.delegate = self
        controller.pageIndex = index
        // 인덱스 따라서 뷰에 뿌려주기
        return controller
    }
}

extension PromotionReviewContainerViewController {
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
                    guard let userRecord = UserRecord.fetch().first else { return }
                    let myGrade = userRecord.grade
                    if myGrade != 2 {
                        UserRecord.update(userRecord, keyValue: ["grade": myGrade + 1])
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

extension PromotionReviewContainerViewController: QuizViewDelegate {
    func didTouchUpQuizButtons(_ sender: UIButton) {
        let index = pageControl.currentPage
        guard let quizView = viewController(at: index)?.quizView else { return }
        guard let title = sender.titleLabel?.text else { return }
        self.answers[index] = title
        if let selectedIndex = quizs[index].answers.index(of: title) {
            quizView[selectedIndex].isSelected = true
        }
    }
}

extension PromotionReviewContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? PromotionReviewContentViewController else { return nil }
        guard let index = controller.pageIndex else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return self.viewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? PromotionReviewContentViewController else { return nil }
        guard let index = controller.pageIndex else { return nil }
        let nextIndex = index + 1
        if nextIndex >= quizs.count {
            return nil
        }
        return self.viewController(at: nextIndex)
    }
}

extension PromotionReviewContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first as? PromotionReviewContentViewController else { return }
        pageControl.currentPage = pageContentViewController.pageIndex
    }
}
