//
//  PromotionReviewViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 22..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

struct Quiz {
    let title: String
    let correctAnswer: String
    let correctAnswerIndex: Int
    let incorrectAnswers: [String]
}

class PromotionReviewViewController: UIViewController {

    let cellIdentifier = "promotionReviewCell"
    var quizs: [Quiz] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //10개 문제 생성하기
    }
}

extension PromotionReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PromotionReviewCell else { return UITableViewCell() }
        cell.setProperties()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width
    }
}

extension PromotionReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
