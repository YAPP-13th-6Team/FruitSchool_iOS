//
//  BaseContainerViewController.swift
//  FruitSchool
//
//  Created by Presto on 12/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

protocol Exercisable: class {
    func executeScoring()
    func makeExercises()
}

class BaseContainerViewController: UIViewController {

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
    var quizs: [Question] = []
    var quizsCount: Int {
        return quizs.count
    }
    var pageViewController: UIPageViewController!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup() {
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
    
    func makeContentViewController(at index: Int) -> BaseContentViewController? {
        guard let controller = UIViewController.instantiate(storyboard: "Base", identifier: BaseContentViewController.classNameToString) as? BaseContentViewController else { return nil }
        controller.pageIndex = index
        guard let quizView = UIView.instantiateFromXib(xibName: "QuizView") as? QuestionView else { return nil }
        let quiz = quizs[index]
        quizView.numberLabel.text = "문제 \(index + 1)"
        quizView.titleLabel.text = quiz.title
        for buttonIndex in 0..<4 {
            quizView[buttonIndex].setTitle(quiz.answers[buttonIndex], for: [])
        }
        if let selectedIndex = quizs[index].answers.index(of: answers[index]) {
            quizView[selectedIndex].backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        }
        quizView.delegate = self
        controller.quizView = quizView
        return controller
    }
}
// MARK: - Selectors
extension BaseContainerViewController {
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
        // 채점 로직
    }
}
// MARK: - QuizView Custom Delegate Implementation
extension BaseContainerViewController: QuestionViewDelegate {
    func didTouchUpQuizButtons(_ sender: UIButton) {
        let currentPageIndex = pageControl.currentPage
        guard let quizView = (pageViewController.viewControllers?[currentPageIndex] as? ExerciseContentViewController)?.questionView else { return }
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
extension BaseContainerViewController: UIPageViewControllerDataSource {
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
extension BaseContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first as? ExerciseContentViewController else { return }
        pageControl.currentPage = pageContentViewController.pageIndex
    }
}
