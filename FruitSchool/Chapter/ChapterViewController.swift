//
//  GuideBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class ChapterViewController: UIViewController {

    var grade: Int = 0
    private let cellIdentifier = "chapterCell"
    private var fruits: [FruitListResponse.Data] = []
    private lazy var records = ChapterRecord.fetch()
    private var countLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            let flowLayout = UICollectionViewFlowLayout()
            let width = (UIScreen.main.bounds.width - 30) / 3
            flowLayout.itemSize = CGSize(width: width, height: width)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
            flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 16)
            flowLayout.footerReferenceSize = .zero
            flowLayout.minimumLineSpacing = 8
            flowLayout.minimumInteritemSpacing = 8
            collectionView.collectionViewLayout = flowLayout
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTopImage()
        setBackButton()
        requestFruitList()
    }
}
// MARK: - ExerciseContainerViewController Custom Delegate Implementation
extension ChapterViewController: ExerciseDelegate {
    // 과일 문제 풀이 종료 후 챕터로 돌아왔을 때의 인터렉션 정의
    func didDismissExerciseViewController(fruitTitle: String, english: String) {
        guard let popup = UIViewController.instantiate(storyboard: "Popup", identifier: FruitCompletePopupViewController.classNameToString) as? FruitCompletePopupViewController else { return }
        popup.fruitTitle = fruitTitle
        popup.english = english
        popup.grade = grade
        popup.handler = {
            self.collectionView.reloadSections(IndexSet(0...0))
            let filtered = self.records.filter("grade = %d", self.grade)
            let passed = filtered.filter("isPassed = true")
            if filtered.count == passed.count {
                guard let finishPopup = UIViewController.instantiate(storyboard: "Popup", identifier: ChapterClearPopupViewController.classNameToString) as? ChapterClearPopupViewController else { return }
                finishPopup.grade = self.grade
                self.present(finishPopup, animated: true, completion: nil)
            }
        }
        present(popup, animated: true, completion: nil)
    }
}
// MARK: - UICollectionView DataSource Implementation
extension ChapterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ChapterCell else { return UICollectionViewCell() }
        let fruit = fruits[indexPath.item]
        guard let filteredRecord = records.filter("id = %@", fruit.id).first else { return UICollectionViewCell() }
        cell.setProperties(fruit, grade: grade, isPassed: filteredRecord.isPassed)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fruits.count
    }
}
// MARK: - UICollectionView Delegate Implementation
extension ChapterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // 과일 카드를 획득했으면 세부 정보 페이지로, 획득하지 않았으면 문제 풀이 페이지로 이동
        guard let isPassed = records.filter("id = %@", fruits[indexPath.item].id).first?.isPassed else { return }
        let fruit = fruits[indexPath.item]
        let id = fruit.id
        if isPassed {
            guard let next = UIViewController.instantiate(storyboard: "Detail", identifier: DetailViewController.classNameToString) as? DetailViewController else { return }
            next.id = id
            next.nth = indexPath.item + 1
            navigationController?.pushViewController(next, animated: true)
        } else {
            guard let next = UIViewController.instantiate(storyboard: "Exercise", identifier: ExerciseContainerViewController.classNameToString) as? ExerciseContainerViewController else { return }
            next.delegate = self
            next.id = id
            next.fruitTitle = fruit.title
            next.english = fruit.english
            present(next, animated: true, completion: nil)
        }
    }
}

private extension ChapterViewController {
    func requestFruitList() {
        SVProgressHUD.show()
        API.requestFruitList { response, _, error in
            SVProgressHUD.dismiss()
            if let error = error {
                DispatchQueue.main.async {
                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription, handler: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                return
            }
            guard let response = response else { return }
            // 교과서의 등급에 맞는 데이터 필터링
            let filtered = response.data.filter { $0.grade == self.grade }
            self.fruits = filtered
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setTopImage() {
        let topImage = UIImageView()
        topImage.contentMode = .scaleAspectFit
        topImage.image = UIImage(named: ChapterTopImage.allCases[grade].rawValue)
        navigationItem.titleView = topImage
    }
    
    func setBackButton() {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "과일목록"
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}
