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
    var searchBar: UISearchBar!
    var searchButton: UIBarButtonItem!
    var fruits: [FruitListResponse.Data] = []
    var searchedFruits: [FruitListResponse.Data] = []
    var isSearching: Bool {
        return searchBar.isFirstResponder
    }
    let records = ChapterRecord.fetch()
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo_noncircle"))
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTouchUpSearchButton(_:)))
        self.navigationItem.setRightBarButton(searchButton, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestFruitList { response, statusCode, error in
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
            let filtered = response.data.filter { $0.grade == self.grade }
            self.fruits = filtered
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
}
// MARK: - Button Touch Event
extension ChapterViewController {
    @objc func didTouchUpSearchButton(_ sender: UIBarButtonItem) {
        searchBar.becomeFirstResponder()
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.titleView = searchBar
    }
}
// MARK: - Search Bar Delegate
extension ChapterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filtered = fruits.filter { $0.title.range(of: searchText) != nil }
        self.searchedFruits = filtered
        self.collectionView.reloadSections(IndexSet(0...0))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.collectionView.reloadSections(IndexSet(0...0))
        navigationItem.titleView = nil
        navigationItem.setRightBarButton(searchButton, animated: true)
    }
}

extension ChapterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ChapterCell else { return UICollectionViewCell() }
        let fruit = fruits[indexPath.item]
        guard let filteredRecord = records.filter("id = %@", fruit.id).first else { return UICollectionViewCell() }
        if !isSearching {
            cell.setProperties(fruit, isPassed: filteredRecord.isPassed)
        } else {
            cell.setProperties(fruit, isPassed: filteredRecord.isPassed)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !isSearching ? fruits.count : searchedFruits.count
    }
}

extension ChapterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let isPassed = records.filter("id = %@", fruits[indexPath.item].id).first?.isPassed else { return }
        let id = fruits[indexPath.item].id
        if isPassed {
            guard let next = UIViewController.instantiate(storyboard: "Detail", identifier: DetailViewController.classNameToString) as? DetailViewController else { return }
            next.id = id
            self.navigationController?.pushViewController(next, animated: true)
        } else {
            guard let next = UIViewController.instantiate(storyboard: "Exercise", identifier: ExerciseViewController.classNameToString) as? ExerciseViewController else { return }
            next.id = id
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
}

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
