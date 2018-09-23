//
//  FruitBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class FruitBookViewController: UIViewController {

    var finishesCommonSensesRequest: Bool = false
    var finishesFruitsRequest: Bool = false
    var finishingCount: Int = 0 {
        didSet {
            if finishingCount == 2 {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    var searchBar = UISearchBar()
    var searchButton: UIBarButtonItem!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(touchUpSearchButton(_:)))
        searchBar.delegate = self
        navigationItem.setRightBarButton(searchButton, animated: true)
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCommonSenses(_:)), name: .didReceiveCommonSenses, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(errorReceiveCommonSenses(_:)), name: .errorReceiveCommonSenses, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveFruits(_:)), name: .didReceiveFruits, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(errorReceiveFruits(_:)), name: .errorReceiveFruits, object: nil)
    }
}
// MARK: - Notification Handler
extension FruitBookViewController {
    @objc func didReceiveCommonSenses(_ notification: Notification) {
        guard let commonSenses = notification.userInfo?["commonSenses"] as? CommonSenseResponse else { return }
        DispatchQueue.global().sync {
            finishingCount += 1
        }
    }
    
    @objc func errorReceiveCommonSenses(_ notification: Notification) {
        guard let error = notification.userInfo?["error"] as? String else { return }
        UIAlertController.presentErrorAlert(to: self, error: error)
    }
    
    @objc func didReceiveFruits(_ notification: Notification) {
        guard let fruits = notification.userInfo?["fruits"] as? [FruitResponse] else { return }
        DispatchQueue.global().sync {
            finishingCount += 1
        }
    }
    
    @objc func errorReceiveFruits(_ notification: Notification) {
        guard let error = notification.userInfo?["error"] as? String else { return }
        UIAlertController.presentErrorAlert(to: self, error: error)
    }
}
// MARK: - Button Touch Event
extension FruitBookViewController {
    @objc func touchUpSearchButton(_ sender: UIBarButtonItem) {
        searchBar.becomeFirstResponder()
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.titleView = searchBar
    }
}

extension FruitBookViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.setRightBarButton(searchButton, animated: true)
    }
}
