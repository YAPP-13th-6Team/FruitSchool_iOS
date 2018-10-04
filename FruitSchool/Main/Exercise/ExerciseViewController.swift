//
//  ExerciseViewController.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    var id: String = ""
    let cellIdentifier = "exerciseCell"
    var exerciseResponse: ExerciseResponse.Data?
    var fruitTitle: String? {
        return exerciseResponse?.title
    }
    var quizs: [QuizResponse]? {
        return exerciseResponse?.quizs
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        API.requestExercises(by: id) { response, statusCode, error in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription, handler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                return
            }
            guard let response = response else { return }
            self.exerciseResponse = response.data
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ExerciseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ExerciseCell else { return UICollectionViewCell() }
        let quiz = quizs?[indexPath.item]
        cell.setProperties(quiz)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizs?.count ?? 0
    }
}

extension ExerciseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ExerciseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        return CGSize(width: width, height: width * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
