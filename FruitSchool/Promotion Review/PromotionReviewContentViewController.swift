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
        questionView.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.top)
            maker.leading.equalTo(view.snp.leading)
            maker.trailing.equalTo(view.snp.trailing)
            maker.bottom.equalTo(view.snp.bottom)
        }
    }
}
