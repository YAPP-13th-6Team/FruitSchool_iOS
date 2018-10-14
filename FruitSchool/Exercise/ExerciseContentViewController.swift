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
    var questionView: QuestionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        makeQuestionView()
    }
    
    func setup() {
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
    
    func makeQuestionView() {
        if questionView == nil {
            questionView = UIView.instantiateFromXib(xibName: "QuestionView") as? QuestionView
        }
        view.addSubview(questionView)
        questionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: view.topAnchor),
            questionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            questionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
