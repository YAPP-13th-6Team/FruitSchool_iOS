//
//  PromotionReviewContentViewController.swift
//  FruitSchool
//
//  Created by Presto on 08/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit
import SnapKit

class PromotionReviewContentViewController: UIViewController {
    
    var pageIndex: Int!
    
    var questionView: QuestionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        makeQuestionView()
    }
    
    private func makeQuestionView() {
        if questionView == nil {
            questionView = UIView.instantiateFromXib(xibName: "QuestionView") as? QuestionView
        }
        view.addSubview(questionView)
        questionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
