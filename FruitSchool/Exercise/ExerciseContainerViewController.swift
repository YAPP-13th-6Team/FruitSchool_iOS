//
//  ExerciseContainerViewController.swift
//  FruitSchool
//
//  Created by Presto on 08/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

// 과일 문제 풀이 뷰컨트롤러의 상태를 다른 뷰컨트롤러에 전달하기 위한 커스텀 델리게이트 정의
protocol ExerciseDelegate: class {
    func didDismissExerciseViewController(fruitTitle: String, english: String)
}

class ExerciseContainerViewController: UIViewController {

    weak var delegate: ExerciseDelegate?
    // 사용자가 선택한 보기가 기록되는 전역 프로퍼티
    var answers: [String] = [] {
        didSet {
            let filtered = answers.filter { !$0.isEmpty }
            DispatchQueue.main.async {
                if filtered.count == self.questions.count {
                    UIView.animate(withDuration: 0.2) {
                        self.submitButton.alpha = 1
                    }
                }
            }
        }
    }
    var score: Int = 0
    var isPassed: [Bool] = []
    var didExecutesScoring: Bool = false
    var id: String = ""
    var fruitTitle: String = ""
    var english: String = ""
    var questions: [Question] = []
    var pageViewController: UIPageViewController!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewCenterYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeQuestions()
    }
    // 문제 만들기
    private func makeQuestions() {
        IndicatorView.shared.showIndicator()
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
            // 서버에서 받은 데이터를 클라이언트에서 사용하기 좋게 주무르기
            for data in response.data.quizs {
                let question = Question(title: data.title, fruitName: data.fruitTitle, correctAnswer: data.correctAnswer, answers: [[data.correctAnswer], data.incorrectAnswers].flatMap { $0 }.shuffled())
                self.questions.append(question)
            }
            // 정답이 기록될 전역 프로퍼티 배열 초기화
            self.answers = Array(repeating: "", count: self.questions.count)
            self.isPassed = Array(repeating: false, count: self.questions.count)
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
        submitButton.layer.cornerRadius = submitButton.bounds.height / 2
        submitButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        submitButton.backgroundColor = .white
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        submitButton.setTitleColor(.black, for: [])
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        pageControl.numberOfPages = questions.count
        self.pageViewController = childViewControllers.first as? UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([makeContentViewController(at: 0) ?? UIViewController()], direction: .forward, animated: true, completion: nil)
    }
    // 페이지 이동시 새로운 뷰컨트롤러 instantiate
    private func makeContentViewController(at index: Int) -> ExerciseContentViewController? {
        let controller = ExerciseContentViewController()
        controller.pageIndex = index
        guard let questionView = UIView.instantiateFromXib(xibName: "QuestionView") as? QuestionView else { return nil }
        let question = questions[index]
        // 문제 뷰에 데이터 뿌리기
        questionView.numberLabel.text = "문제 \(index + 1)"
        let attributedString = NSMutableAttributedString(string: question.title, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .ultraLight)])
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30, weight: .medium)]
        let range = (question.title as NSString).range(of: question.fruitName)
        attributedString.addAttributes(boldFontAttribute, range: range)
        questionView.titleLabel.attributedText = attributedString
        for buttonIndex in 0..<4 {
            questionView[buttonIndex].setTitle(question.answers[buttonIndex], for: [])
        }
        // 정답을 기록한 문항에는 정답에 대응하는 보기에 선택된 효과를 주기
        if let selectedIndex = question.answers.index(of: answers[index]) {
            questionView[selectedIndex].backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        }
        // 채점 이후
        if didExecutesScoring {
            let correctIndex = question.answers.index(of: question.correctAnswer) ?? 0
            if isPassed[index] {
                questionView.markImageView.image = UIImage(named: "mark_correct")
                questionView[correctIndex].backgroundColor = .correct
            } else {
                questionView.markImageView.image = UIImage(named: "mark_incorrect")
                questionView[correctIndex].layer.borderWidth = 2
                questionView[correctIndex].layer.borderColor = UIColor.incorrect.cgColor
            }
            
        }
        questionView.delegate = self
        controller.questionView = questionView
        return controller
    }
}
// MARK: - Selectors
extension ExerciseContainerViewController {
    // 제출하기 버튼을 눌러서 채점하기
    @objc func didTouchUpSubmitButton(_ sender: UIButton) {
        executeScoring()
    }
}

// MARK: - Scoring Logic
extension ExerciseContainerViewController {
    private func executeScoring() {
        UIAlertController
            .alert(title: "", message: "제출할까요?")
            .action(title: "확인", style: .default) { _ in
                self.didExecutesScoring = true
                for index in 0..<self.questions.count {
                    let question = self.questions[index]
                    let answer = self.answers[index]
                    if question.correctAnswer == answer {
                        self.isPassed[index] = true
                    } else {
                        self.isPassed[index] = false
                    }
                }
                guard let controller = self.pageViewController.viewControllers?.first as? ExerciseContentViewController else { print(1); return }
                guard let questionView = controller.questionView else { return }
                let currentIndex = self.pageControl.currentPage
                let correctIndex = self.questions[currentIndex].answers.index(of: self.questions[currentIndex].correctAnswer) ?? 0
                if self.isPassed[currentIndex] {
                    questionView.markImageView.image = UIImage(named: "mark_correct")
                    questionView[correctIndex].backgroundColor = .correct
                } else {
                    questionView.markImageView.image = UIImage(named: "mark_incorrect")
                    questionView[correctIndex].layer.borderWidth = 2
                    questionView[correctIndex].layer.borderColor = UIColor.incorrect.cgColor
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.submitButton.alpha = 0
                }, completion: { _ in
                    self.submitButton.isHidden = true
                })
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
extension ExerciseContainerViewController: QuestionViewDelegate {
    func questionButtonsDidTouchUp(_ sender: UIButton) {
        let currentPageIndex = pageControl.currentPage
        guard let questionView = (pageViewController.viewControllers?[currentPageIndex] as? ExerciseContentViewController)?.questionView else { return }
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
        let score = numberOfCorrectAnswers()
        if score == questions.count {
            guard let record = ChapterRecord.fetch().filter("id = %@", id).first else { return }
            ChapterRecord.update(record, keyValue: ["isPassed": true])
            dismiss(animated: true) {
                self.delegate?.didDismissExerciseViewController(fruitTitle: self.fruitTitle, english: self.english)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
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
        if nextIndex >= questions.count {
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
