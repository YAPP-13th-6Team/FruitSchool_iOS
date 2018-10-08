//
//  ExerciseContentViewController.swift
//  FruitSchool
//
//  Created by Presto on 08/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class ExerciseContentViewController: UIViewController {

    var pageIndex: Int!
    var quizView: QuizView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        makeQuizView()
    }
    
    func setup() {
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
    
    func makeQuizView() {
        if quizView == nil {
            quizView = UIView.instantiateFromXib(xibName: "QuizView") as? QuizView
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
