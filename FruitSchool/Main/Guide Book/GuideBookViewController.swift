//
//  GuideBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class GuideBookViewController: UIViewController {

    let titleString: String = "과일 도감"
    let cellIdentifier = "guideBookCell"
    var searchBar: UISearchBar!
    var searchButton: UIBarButtonItem!
    var fruits: [[FruitResponse]] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleString
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(touchUpSearchButton(_:)))
        self.navigationItem.setRightBarButton(searchButton, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveFruits(_:)), name: .didReceiveFruits, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(errorReceiveFruits(_:)), name: .errorReceiveFruits, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        API.requestFruits()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - Notification Handler
extension GuideBookViewController {
    /// 전체 과일 정보 요청 성공 핸들러
    @objc func didReceiveFruits(_ notification: Notification) {
        guard let fruits = notification.userInfo?["fruits"] as? [FruitResponse] else { return }
        let grade0Fruits = fruits.filter { $0.grade == 0 }
        let grade1Fruits = fruits.filter { $0.grade == 1 }
        let grade2Fruits = fruits.filter { $0.grade == 2 }
        let tempFruits = [grade0Fruits, grade1Fruits, grade2Fruits]
        self.fruits = tempFruits
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    /// 전체 과일 정보 요청 실패 핸들러
    @objc func errorReceiveFruits(_ notification: Notification) {
        guard let error = notification.userInfo?["error"] as? String else { return }
        UIAlertController.presentErrorAlert(to: self, error: error)
    }
}
// MARK: - Button Touch Event
extension GuideBookViewController {
    @objc func touchUpSearchButton(_ sender: UIBarButtonItem) {
        searchBar.becomeFirstResponder()
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.titleView = searchBar
    }
}

extension GuideBookViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.title = titleString
        navigationItem.setRightBarButton(searchButton, animated: true)
    }
}

extension GuideBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GuideBookCell else { return UICollectionViewCell() }
        let fruit = fruits[indexPath.section][indexPath.row]
        cell.setProperties(fruit)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fruits[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fruits.count
    }
}

extension GuideBookViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let next = UIViewController.instantiate(storyboard: "Detail", identifier: "DetailViewController") as? DetailViewController else { return }
        next.fruit = fruits[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension GuideBookViewController: UICollectionViewDelegateFlowLayout {
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
