//
//  FruitBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    let cellIdentifier = "bookCell"
    var searchBar = UISearchBar()
    var searchButton: UIBarButtonItem!
    var percentLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        percentLabel = UILabel()
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTouchUpSearchButton(_:)))
        searchBar.delegate = self
        navigationItem.setRightBarButton(searchButton, animated: true)
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
    }
}
// MARK: - Button Touch Event
extension BookViewController {
    @objc func didTouchUpSearchButton(_ sender: UIBarButtonItem) {
        searchBar.becomeFirstResponder()
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.titleView = searchBar
    }
}

extension BookViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.setRightBarButton(searchButton, animated: true)
    }
}

extension BookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? BookCell else { return UICollectionViewCell() }
        cell.setProperties(at: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

extension BookViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let myGrade = UserDefaults.standard.integer(forKey: "grade")
        if myGrade < indexPath.item {
            UIAlertController.presentErrorAlert(to: self, error: "승급심사 보고 오세요")
            return
        }
        guard let next = UIViewController.instantiate(storyboard: "Chapter", identifier: ChapterViewController.classNameToString) as? ChapterViewController else { return }
        next.grade = UserDefaults.standard.integer(forKey: "grade")
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension BookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height  = collectionView.bounds.height
        return CGSize(width: height * 0.8, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
