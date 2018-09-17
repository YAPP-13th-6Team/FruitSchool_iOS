//
//  GuideBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class GuideBookViewController: UIViewController {

    let cellIdentifier = "guideBookCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        self.navigationItem.title = "과일 도감"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(touchUpSearchButton(_:)))
        self.navigationItem.setRightBarButton(searchButton, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension GuideBookViewController {
    @objc func touchUpSearchButton(_ sender: UIBarButtonItem) {
        
    }
}

extension GuideBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? GuideBookCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
}

extension GuideBookViewController: UICollectionViewDelegate {
    
}

extension GuideBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 3 - 20
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
}
