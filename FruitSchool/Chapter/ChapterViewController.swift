//
//  GuideBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class ChapterViewController: UIViewController {

    var grade: Int = 0
    let cellIdentifier = "chapterCell"
    var fruits: [FruitListResponse.Data] = []
    let records = ChapterRecord.fetch()
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 내비게이션 타이틀에 들어갈 이미지 설정
        switch grade {
        case 0:
            navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "dog_top"))
        case 1:
            navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "student_top"))
        case 2:
            navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "boss_top"))
        default:
            break
        }
        // 이전 버튼에 들어갈 문자열 설정
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "과일목록"
        navigationItem.backBarButtonItem = backBarButtonItem
        // 과일 목록 요청하기
        requestFruitList()
    }
}
// MARK: - Making Fruit List
extension ChapterViewController {
    func requestFruitList() {
        IndicatorView.shared.showIndicator()
        API.requestFruitList { response, _, error in
            IndicatorView.shared.hideIndicator()
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription, handler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                return
            }
            guard let response = response else { return }
            // 교과서의 등급에 맞는 데이터 필터링
            let filtered = response.data.filter { $0.grade == self.grade }
            self.fruits = filtered
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}
// MARK: - ExerciseContainerViewController Custom Delegate Implementation
extension ChapterViewController: ExerciseDelegate {
    // 과일 문제 풀이 종료 후 챕터로 돌아왔을 때의 인터렉션 정의
    func didDismissExerciseViewController(_ fruitTitle: String) {
        guard let popup = UIViewController.instantiate(storyboard: "Popup", identifier: FruitCompletePopupViewController.classNameToString) as? FruitCompletePopupViewController else { return }
        popup.fruitTitle = fruitTitle
        popup.grade = grade
        popup.handler = {
            self.collectionView.reloadSections(IndexSet(0...0))
            let filtered = self.records.filter("grade = %d", self.grade)
            let passed = filtered.filter("isPassed = true")
            if filtered.count == passed.count {
                guard let finishPopup = UIViewController.instantiate(storyboard: "Popup", identifier: ChapterFinishPopupViewController.classNameToString) as? ChapterFinishPopupViewController else { return }
                finishPopup.grade = self.grade
                self.present(finishPopup, animated: true, completion: nil)
            }
        }
        present(popup, animated: true, completion: nil)
//        UIAlertController
//            .alert(title: "\(fruitTitle) 학습 완료!", message: nil)
//            .action(title: "확인") { _ in
//                self.requestFruitList()
//                let filtered = self.records.filter("grade = %d", self.grade)
//                let passed = filtered.filter("isPassed = true")
//                if filtered.count == passed.count {
//                    UIAlertController
//                        .alert(title: "축하합니다!\n\(Grade(rawValue: self.grade)?.expression ?? "") 등급의 모든 문제를 풀었습니다.", message: nil)
//                        .action(title: "확인")
//                        .present(to: self)
//                }
//            }
//            .present(to: self)
    }
}
// MARK: - UICollectionView DataSource Implementation
extension ChapterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ChapterCell else { return UICollectionViewCell() }
        let fruit = fruits[indexPath.item]
        guard let filteredRecord = records.filter("id = %@", fruit.id).first else { return UICollectionViewCell() }
        cell.setProperties(fruit, isPassed: filteredRecord.isPassed)
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
            self.navigationController?.pushViewController(next, animated: true)
        } else {
            guard let next = UIViewController.instantiate(storyboard: "Exercise", identifier: ExerciseContainerViewController.classNameToString) as? ExerciseContainerViewController else { return }
            next.delegate = self
            next.id = id
            next.fruitTitle = fruit.title
            self.present(next, animated: true, completion: nil)
        }
    }
}
// MARK: - UICollectionView DelegateFlowLayout Implementation
extension ChapterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 4 - 10
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
