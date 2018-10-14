//
//  BaseContentViewController.swift
//  FruitSchool
//
//  Created by Presto on 12/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class BaseContentViewController: UIViewController {

    var pageIndex: Int!
    var quizView: QuestionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        makeQuizView()
    }
    
    private func setup() {
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
    
    private func makeQuizView() {
        if quizView == nil {
            quizView = UIView.instantiateFromXib(xibName: "QuizView") as? QuestionView
        }
        view.addSubview(quizView)
        quizView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quizView.topAnchor.constraint(equalTo: view.topAnchor),
            quizView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quizView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            quizView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
