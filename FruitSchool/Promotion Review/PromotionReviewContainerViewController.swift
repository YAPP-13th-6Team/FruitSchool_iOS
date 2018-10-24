//
//  PromotionReviewContainerViewController.swift
//  FruitSchool
//
//  Created by Presto on 08/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

// 승급심사 뷰컨트롤러의 상태를 다른 뷰컨트롤러에 전달하기 위한 커스텀 델리게이트 정의
protocol PromotionReviewDelegate: class {
    func didDismissPromotionReviewViewController(_ grade: Int)
}

class PromotionReviewContainerViewController: UIViewController {

    weak var delegate: PromotionReviewDelegate?
    // 사용자가 선택한 보기가 기록되는 전역 프로퍼티
    var answers: [String] = [] {
        didSet {
            let filtered = answers.filter { !$0.isEmpty }
            DispatchQueue.main.async {
                if filtered.count == self.questions.count {
                    UIView.animate(withDuration: 0.5) {
                        self.submitButton.alpha = 1
                        self.checksAllQuestion = true
                    }
                }
            }
        }
    }
    var checksAllQuestion: Bool = false
    var grade: Int = 0
    var questions: [Question] = []
    var pageViewController: UIPageViewController!
    @IBOutlet weak var submitButton: QuestionButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeQuestions()
    }
    
    private func makeQuestions() {
        IndicatorView.shared.showIndicator()
        API.requestExam(by: grade) { response, _, error in
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
            // 서버에서 받은 데이터를 클라이언트에서 사용하기 좋게 주무르기
            for data in response.data {
                let question = Question(title: data.title, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.questions.append(question)
            }
            // 정답이 기록될 전역 프로퍼티 배열 초기화
            self.answers = Array(repeating: "", count: self.questions.count)
            // 문제 뷰가 커지는 애니메이션 후 페이지 인디케이터 노출
            DispatchQueue.main.async {
                self.setUp()
                self.containerView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
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
        //containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanContentView(_:))))
        pageControl.numberOfPages = questions.count
        self.pageViewController = childViewControllers.first as? UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([makeContentViewController(at: 0) ?? UIViewController()], direction: .forward, animated: true, completion: nil)
    }
    // 페이지 이동시 새로운 뷰컨트롤러 instantiate
    private func makeContentViewController(at index: Int) -> PromotionReviewContentViewController? {
        guard let questionView = UIView.instantiateFromXib(xibName: "QuestionView") as? QuestionView else { return nil }
        questionView.delegate = self
        let question = questions[index]
        // 문제 뷰에 데이터 뿌리기
        questionView.numberLabel.text = "문제 \(index + 1)"
        questionView.titleLabel.text = question.title
        for buttonIndex in 0..<4 {
            questionView[buttonIndex].setTitle(question.answers[buttonIndex], for: [])
        }
        if let selectedIndex = questions[index].answers.index(of: answers[index]) {
            questionView[selectedIndex].backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        }
        let controller = PromotionReviewContentViewController()
        controller.questionView = questionView
        controller.pageIndex = index
        return controller
    }
}
// MARK: - Selectors
extension PromotionReviewContainerViewController {
    // 문제 뷰를 아래로 내렸을 때 사라지게 하는 효과
//    @objc func didPanContentView(_ gesture: UIPanGestureRecognizer) {
//        let velocityY = gesture.translation(in: view).y
//        switch gesture.state {
//        case .changed:
//            if velocityY >= 0 {
//                containerViewCenterYConstraint.constant = velocityY
//            }
//            if checksAllQuestion {
//                UIView.animate(withDuration: 0.1) {
//                    self.submitButton.alpha = 0
//                }
//            }
//        case .ended:
//            if gesture.velocity(in: view).y > 1000 {
//                containerViewCenterYConstraint.constant = view.bounds.height
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.view.layoutIfNeeded()
//                }, completion: { _ in
//                    self.dismiss(animated: true, completion: nil)
//                })
//                return
//            } else {
//                if checksAllQuestion {
//                    UIView.animate(withDuration: 0.1) {
//                        self.submitButton.alpha = 1
//                    }
//                }
//                containerViewCenterYConstraint.constant = 0
//                UIView.animate(withDuration: 0.2) {
//                    self.view.layoutIfNeeded()
//                }
//            }
//        default:
//            break
//        }
//    }
    // 제출하기 버튼을 눌러서 채점하기
    @objc func didTouchUpSubmitButton(_ sender: UIButton) {
        executeScoring()
    }
}
// MARK: - Scoring Logic
extension PromotionReviewContainerViewController {
    private func executeScoring() {
        var score = 0
        UIAlertController
            .alert(title: "승급 심사", message: "제출할까요?")
            .action(title: "확인") { _ in
                // 맞은 문항 개수 세기
                score = self.numberOfCorrectAnswers()
                // 정답율이 70% 이상이면 통과, 그렇지 않으면 불통
                let percent = Double(score) / Double(self.questions.count)
                if percent > 0.7 {
                    UIAlertController
                        .alert(title: "결과", message: "통과")
                        .action(title: "확인", handler: { _ in
                            guard let userRecord = UserRecord.fetch().first else { return }
                            let myGrade = userRecord.grade
                            if myGrade != 2 {
                                UserRecord.update(userRecord, keyValue: ["grade": myGrade + 1])
                                IndicatorView.shared.showIndicator()
                                API.requestGradeUp(myGrade, completion: { _, _, error in
                                    if let error = error {
                                        UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                                        return
                                    }
                                })
                            }
                            switch self.grade {
                            case 0:
                                UserRecord.update(userRecord, keyValue: ["passesDog": true])
                            case 1:
                                UserRecord.update(userRecord, keyValue: ["passesStudent": true])
                            case 2:
                                UserRecord.update(userRecord, keyValue: ["passesBoss": true])
                            default:
                                break
                            }
                            IndicatorView.shared.hideIndicator()
                            self.dismiss(animated: true, completion: {
                                self.delegate?.didDismissPromotionReviewViewController(self.grade)
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
    
    private func numberOfCorrectAnswers() -> Int {
        var score = 0
        for index in 0..<questions.count {
            let question = questions[index]
            let answer = answers[index]
            if question.correctAnswer == answer {
                score += 1
            }
        }
        return score
    }
}
// MARK: - QuestionView Custom Delegate Implementation
extension PromotionReviewContainerViewController: QuestionViewDelegate {
    func questionButtonsDidTouchUp(_ sender: UIButton) {
        let currentPageIndex = pageControl.currentPage
        guard let questionView = (pageViewController.viewControllers?.first as? PromotionReviewContentViewController)?.questionView else { return }
        guard let title = sender.titleLabel?.text else { return }
        // 사용자가 선택한 보기를 answers 전역프로퍼티에 할당하고, 선택된 효과를 주기
        self.answers[currentPageIndex] = title
        for index in 0..<4 {
            UIView.animate(withDuration: 0.2) {
                questionView[index].backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            }
        }
        if let selectedIndex = questions[currentPageIndex].answers.index(of: title) {
            UIView.animate(withDuration: 0.2) {
                questionView[selectedIndex].backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
            }
        }
    }
    
    func cancelButtonDidTouchUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UIPageViewController DataSource Implementation
extension PromotionReviewContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PromotionReviewContentViewController else { return nil }
        guard let index = viewController.pageIndex else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return makeContentViewController(at: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PromotionReviewContentViewController else { return nil }
        guard let index = viewController.pageIndex else { return nil }
        let nextIndex = index + 1
        if nextIndex >= questions.count {
            return nil
        }
        return makeContentViewController(at: nextIndex)
    }
}
// MARK: - UIPageViewController Delegate Implementation
extension PromotionReviewContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let pageContentViewController = pageViewController.viewControllers?.first as? PromotionReviewContentViewController else { return }
        pageControl.currentPage = pageContentViewController.pageIndex
    }
}
