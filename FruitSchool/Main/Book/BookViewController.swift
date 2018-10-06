//
//  FruitBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    let percentLabelTag = 100
    let promotionReviewButtonTag = 101
    let cellIdentifier = "bookCell"
    let record = Record.fetch()
    var searchBar = UISearchBar()
    var searchButton: UIBarButtonItem!
    var percentLabel: UILabel!
    var currentCellIndex: Int = 0
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "교과서"
        slider.setThumbImage(UIImage(), for: [])
        percentLabel = UILabel()
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTouchUpSearchButton(_:)))
        searchBar.delegate = self
        navigationItem.setRightBarButton(searchButton, animated: true)
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetViews()
    }
    
    @objc func didTouchUpPromotionReviewButton(_ sender: UIButton) {
        guard let next = UIViewController.instantiate(storyboard: "PromotionReview", identifier: PromotionReviewViewController.classNameToString) as? PromotionReviewViewController else { return }
        next.grade = currentCellIndex
        navigationController?.pushViewController(next, animated: true)
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let myGrade = UserDefaults.standard.integer(forKey: "grade")
        if !(0...myGrade).contains(indexPath.item) {
            UIAlertController.presentErrorAlert(to: self, error: "승급심사 보고 오세요")
            return
        }
        guard let next = UIViewController.instantiate(storyboard: "Chapter", identifier: ChapterViewController.classNameToString) as? ChapterViewController else { return }
        next.grade = indexPath.item
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

private extension BookViewController {
    func resetViews() {
        setSliderValues()
        setLabelPositionAndText()
        showPromotionReviewButton()
    }
    
    func setSliderValues() {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let index = collectionView.indexPathForItem(at: visiblePoint)?.item else { return }
        currentCellIndex = index
        let filtered = record.filter("grade = %d", index)
        let count = filtered.count
        var passedCount = 0
        for element in filtered where element.isPassed {
            passedCount += 1
        }
        slider.maximumValue = Float(count)
        slider.value = Float(passedCount)
    }
    
    func setLabelPositionAndText() {
        view.viewWithTag(percentLabelTag)?.removeFromSuperview()
        percentLabel.tag = percentLabelTag
        view.addSubview(percentLabel)
        if slider.value == 0 {
            NSLayoutConstraint.activate([
                percentLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
                percentLabel.centerXAnchor.constraint(equalTo: slider.leadingAnchor, constant: 0)
                ])
            percentLabel.text = "0%"
        } else {
            NSLayoutConstraint.activate([
                percentLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
                NSLayoutConstraint(item: percentLabel, attribute: .centerX, relatedBy: .equal, toItem: slider, attribute: .trailing, multiplier: CGFloat(slider.value / slider.maximumValue), constant: CGFloat(32 - 32 * (slider.value / slider.maximumValue)))
                ])
            percentLabel.text = "\(Int(slider.value * 100 / slider.maximumValue))%"
        }
    }
    
    func showPromotionReviewButton() {
        view.viewWithTag(promotionReviewButtonTag)?.removeFromSuperview()
        if slider.value == slider.maximumValue {
            let button = UIButton(type: .system)
            button.tag = promotionReviewButtonTag
            button.setTitle("승급 심사", for: [])
            button.addTarget(self, action: #selector(didTouchUpPromotionReviewButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 20),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                button.heightAnchor.constraint(equalToConstant: 40)
                ])
        }
    }
}
