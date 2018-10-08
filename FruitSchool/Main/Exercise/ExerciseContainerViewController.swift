//
//  ExerciseContainerViewController.swift
//  FruitSchool
//
//  Created by Presto on 08/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

protocol ExerciseDelegate: class {
    func didDismissExerciseViewController()
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
                    }
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.submitButton.alpha = 0
                    }
                }
            }
        }
    }
    var id: String = ""
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
        submitButton.addTarget(self, action: #selector(didTouchUpSubmitButton(_:)), for: .touchUpInside)
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestExercises(by: id) { response, statusCode, error in
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
            }
            self.answers = Array(repeating: "", count: self.quizs.count)
            DispatchQueue.main.async {
                self.setUp()
                self.containerView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.containerView.transform = CGAffineTransform.identity
                }, completion: { isSuccess in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.pageControl.alpha = 1
                    })
                    
                })
            }
        }
    }
    
    func setUp() {
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanContentView(_:))))
        self.pageViewController = childViewControllers.first as? UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        guard let start = self.viewController(at: 0) else { return }
        let viewControllers = NSArray(object: start)
        pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        guard let contentViewControllers = pageViewController.viewControllers as? [ExerciseContentViewController] else { return }
        for index in 0..<contentViewControllers.count {
            let contentViewController = contentViewControllers[index]
            guard let quizView = contentViewController.quizView else { return }
            let quiz = quizs[index]
            quizView.numberLabel.text = "\(index + 1)번 문제"
            quizView.titleLabel.text = quiz.title
            for buttonIndex in 0..<4 {
                quizView[buttonIndex].setTitle(quiz.answers[buttonIndex], for: [])
            }
            contentViewController.quizView.delegate = self
        }
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
    
    func viewController(at index: Int) -> ExerciseContentViewController? {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: ExerciseContentViewController.classNameToString) as? ExerciseContentViewController else { return nil }
        controller.pageIndex = index
        return controller
    }
}

extension ExerciseContainerViewController {
    private func executeScoring() {
        var score = 0
        guard let alertView = UIView.instantiateFromXib(xibName: "AlertView") as? AlertView else { return }
        alertView.titleLabel.text = "과일 문제 풀이"
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
                    self.dismiss(animated: true, completion: {
                        self.delegate?.didDismissExerciseViewController()
                    })
                }
            } else {
                resultView.descriptionLabel.text = "불통"
                resultView.handler = {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            self.view.addSubview(resultView)
        }
        alertView.frame = view.bounds
        view.addSubview(alertView)
    }
}

extension ExerciseContainerViewController: QuizViewDelegate {
    func didTouchUpQuizButtons(_ sender: UIButton) {
        let index = pageControl.currentPage
        guard let quizView = (pageViewController.viewControllers?[index] as? ExerciseContentViewController)?.quizView else { return }
        guard let title = sender.titleLabel?.text else { return }
        self.answers[index] = title
        for index in 0..<4 {
            quizView[index].backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        }
        if let selectedIndex = quizs[index].answers.index(of: title) {
            //quizView[selectedIndex].isSelected = true
            quizView[selectedIndex].backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        }
    }
    
    func didTouchUpCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ExerciseContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? ExerciseContentViewController else { return nil }
        guard let index = controller.pageIndex else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return self.viewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? ExerciseContentViewController else { return nil }
        guard let index = controller.pageIndex else { return nil }
        let nextIndex = index + 1
        if nextIndex >= quizs.count {
            return nil
        }
        return self.viewController(at: nextIndex)
    }
}

extension ExerciseContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first as? ExerciseContentViewController else { return }
        pageControl.currentPage = pageContentViewController.pageIndex
    }
}
