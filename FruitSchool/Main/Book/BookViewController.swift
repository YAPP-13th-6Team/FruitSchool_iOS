//
//  FruitBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    var percentage: CGFloat = 0
    let gaugeLabelTag = 98
    let percentLabelTag = 99
    let descriptionLabelTag = 100
    let promotionReviewButtonTag = 101
    let cellIdentifier = "bookCell"
    let chapterRecord = ChapterRecord.fetch()
    var searchBar: UISearchBar!
    var searchButton: UIBarButtonItem!
    var percentLabel: UILabel!
    var currentCellIndex: Int = 0
    let imageNames = [["cover_dog_unclear", "cover_dog_clear"], ["cover_student_unclear", "cover_student_clear"], ["cover_boss_unclear", "cover_boss_clear"]]
    @IBOutlet weak var backgroundGaugeView: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "교과서"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo_noncircle")))
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.setRightBarButton(searchButton, animated: true)
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTouchUpSearchButton(_:)))
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        percentLabel = UILabel()
        percentLabel.textColor = UIColor.main
        percentLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: backgroundGaugeView.bounds, cornerRadius: backgroundGaugeView.bounds.height / 2)
        shapeLayer.path = path.cgPath
        backgroundGaugeView.layer.mask = shapeLayer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetViews()
        collectionView.reloadSections(IndexSet(0...0))
    }
}
// MARK: - Button Touch Event
extension BookViewController {
    @objc func didTouchUpSearchButton(_ sender: UIBarButtonItem) {
        searchBar.becomeFirstResponder()
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.titleView = searchBar
    }
    
    @objc func didTouchUpPromotionReviewButton(_ sender: UIButton) {
        guard let next = UIViewController.instantiate(storyboard: "PromotionReview", identifier: PromotionReviewContainerViewController.classNameToString) as? PromotionReviewContainerViewController else { return }
        next.delegate = self
        next.grade = currentCellIndex
        self.present(next, animated: true, completion: nil)
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

extension BookViewController: PromotionReviewDelegate {
    func didDismissPromotionReviewViewController() {
        collectionView.reloadSections(IndexSet(0...0))
    }
}

extension BookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? BookCell else { return UICollectionViewCell() }
        guard let userRecord = UserRecord.fetch().first else { return UICollectionViewCell() }
        let fruitsInBook = chapterRecord.filter { $0.grade == indexPath.item }
        let passedFruitsInBook = fruitsInBook.filter { $0.isPassed }
        if userRecord[indexPath.item] {
            cell.coverImageView.image = UIImage(named: imageNames[indexPath.item][1])
            cell.stampImageView.image = #imageLiteral(resourceName: "stamp_clear")
        } else {
            if fruitsInBook.count == passedFruitsInBook.count {
                cell.coverImageView.image = UIImage(named: imageNames[indexPath.item][1])
            } else {
                cell.coverImageView.image = UIImage(named: imageNames[indexPath.item][0])
            }
            cell.stampImageView.image = nil
        }
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
        let myGrade = UserRecord.fetch().first?.grade ?? 0
        if !(0...myGrade).contains(indexPath.item) {
            UIAlertController.presentErrorAlert(to: self, error: "당신은 아직 \(Grade(rawValue: myGrade)?.expression ?? "")예요!")
            return
        }
        guard let next = UIViewController.instantiate(storyboard: "Chapter", identifier: ChapterViewController.classNameToString) as? ChapterViewController else { return }
        next.grade = indexPath.item
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension BookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.8
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

private extension BookViewController {
    func makeGaugeLabel() {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let index = collectionView.indexPathForItem(at: visiblePoint)?.item else { return }
        currentCellIndex = index
        let filtered = chapterRecord.filter("grade = %d", index)
        let count = filtered.count
        var passedCount = 0
        for element in filtered where element.isPassed {
            passedCount += 1
        }
        view.viewWithTag(gaugeLabelTag)?.removeFromSuperview()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .main
        label.tag = gaugeLabelTag
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.737254902, blue: 0.7137254902, alpha: 1)
        let percentage = CGFloat(passedCount) / CGFloat(count)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: backgroundGaugeView.heightAnchor),
            label.leadingAnchor.constraint(equalTo: backgroundGaugeView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: backgroundGaugeView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: backgroundGaugeView.widthAnchor, multiplier: percentage)
            ])
        view.layoutIfNeeded()
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: label.bounds, cornerRadius: label.bounds.height / 2)
        shapeLayer.path = path.cgPath
        label.layer.mask = shapeLayer
        self.percentage = percentage
    }
    
    func makePercentLabel() {
        let leading = backgroundGaugeView.frame.origin.x
        view.viewWithTag(percentLabelTag)?.removeFromSuperview()
        percentLabel.tag = percentLabelTag
        view.addSubview(percentLabel)
        if percentage == 0 {
            NSLayoutConstraint.activate([
                percentLabel.topAnchor.constraint(equalTo: backgroundGaugeView.bottomAnchor, constant: 6),
                percentLabel.centerXAnchor.constraint(equalTo: backgroundGaugeView.leadingAnchor, constant: 0)
                ])
        } else {
            NSLayoutConstraint.activate([
                percentLabel.topAnchor.constraint(equalTo: backgroundGaugeView.bottomAnchor, constant: 6),
                NSLayoutConstraint(item: percentLabel, attribute: .centerX, relatedBy: .equal, toItem: backgroundGaugeView, attribute: .trailing, multiplier: percentage, constant: leading - leading * percentage)
                ])
        }
        percentLabel.text = "\(Int(percentage * 100))%"
    }
    
    func makeDescriptionLabel() {
        view.viewWithTag(descriptionLabelTag)?.removeFromSuperview()
        let label = UILabel()
        label.tag = descriptionLabelTag
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .main
        label.text = "화면을 채워주는 문구"
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 8)
            ])
    }
    
    func makePromotionReviewButton() {
        view.viewWithTag(promotionReviewButtonTag)?.removeFromSuperview()
        let passesCurrentBook = UserRecord.fetch().first?[currentCellIndex] ?? false
        if percentage == 1 && !passesCurrentBook {
            let button = UIButton(type: .system)
            button.tag = promotionReviewButtonTag
            button.setTitle("승급 심사", for: [])
            button.addTarget(self, action: #selector(didTouchUpPromotionReviewButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 40),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                button.heightAnchor.constraint(equalToConstant: 40)
                ])
        }
    }
    
    func resetViews() {
        makeGaugeLabel()
        makePercentLabel()
        makeDescriptionLabel()
        makePromotionReviewButton()
    }
}
