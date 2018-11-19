//
//  FruitBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import FSPagerView
import SnapKit

class BookViewController: UIViewController {

    // 각 교과서의 달성률을 저장하는 프로퍼티
    var percentage: CGFloat = 0
    // 게이지(레이블로 표시함)의 태그. backgroundGaugeView 위에 올라가 달성률을 시각적으로 보여줌
    let gaugeLabelTag = 98
    // 달성률을 표시하는 레이블의 태그
    let percentLabelTag = 99
    // 화면을 비어보이지 않게 하는 레이블의 태그
    let descriptionLabelTag = 100
    // 승급심사 버튼의 태그
    let promotionReviewButtonTag = 101
    let cellIdentifier = "bookCell"
    let chapterRecord = ChapterRecord.fetch()
    let imageNames = [["cover_dog_unclear", "cover_dog_clear"], ["cover_student_unclear", "cover_student_clear"], ["cover_boss_unclear", "cover_boss_clear"]]
    // 달성률을 표시하는 레이블은 전역 프로퍼티에 할당하여 사용
    var percentLabel: UILabel!
    lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl(frame: .zero)
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.19), for: .normal)
        pageControl.setFillColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.68), for: .selected)
        pagerView.addSubview(pageControl)
        return pageControl
    }()
    @IBOutlet weak var backgroundGaugeView: UILabel!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            pagerView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "bookCell")
            pagerView.transformer = FSPagerViewTransformer(type: .linear)
            pagerView.interitemSpacing = 6
            let width = UIScreen.main.bounds.width * 0.83
            pagerView.itemSize = CGSize(width: width, height: width * 398 / 312)
            pagerView.delegate = self
            pagerView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetViews()
        pagerView.reloadData()
        pagerView.scrollToItem(at: 0, animated: true)
    }
    
    private func setup() {
        pageControl.snp.makeConstraints { maker in
            maker.bottom.equalTo(pagerView.snp.bottom).offset(-8)
            maker.centerX.equalTo(view.snp.centerX)
            maker.height.equalTo(20)
        }
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = "교과서"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "logo_noncircle")))
        navigationItem.backBarButtonItem = backBarButtonItem
        percentLabel = UILabel()
        percentLabel.textColor = UIColor.main
        percentLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundGaugeView.layer.cornerRadius = backgroundGaugeView.bounds.height / 2
        backgroundGaugeView.layer.masksToBounds = true
    }
}
// MARK: - Button Touch Event
extension BookViewController {
    // 승급심사 버튼을 누르면 승급심사 뷰컨트롤러로 넘어감
    @objc func didTouchUpPromotionReviewButton(_ sender: UIButton) {
        guard let next = UIViewController.instantiate(storyboard: "PromotionReview", identifier: PromotionReviewContainerViewController.classNameToString) as? PromotionReviewContainerViewController else { return }
        next.delegate = self
        next.grade = pagerView.currentIndex
        self.present(next, animated: true, completion: nil)
    }
}
// MARK: - PromotionReviewContainerViewController Custom Delegate Implementation
extension BookViewController: PromotionReviewDelegate {
    // 승급심사 종료 후 교과서로 돌아왔을 때의 인터렉션 정의
    func didDismissPromotionReviewViewController(_ grade: Int) {
        let title: String
        if grade == 2 {
            title = "축하합니다!\n모든 승급심사를 통과했습니다."
        } else {
            title = "축하합니다!\n당신은 이제 \(Grade(rawValue: grade + 1)?.expression ?? "")입니다."
        }
        UIAlertController
            .alert(title: title, message: nil)
            .action(title: "확인", handler: { _ in
                self.resetViews()
                self.pagerView.reloadData()
            })
            .present(to: self)
    }
}

extension BookViewController: FSPagerViewDataSource {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bookCell", at: index) as? BookCell else { return FSPagerViewCell() }
        guard let userRecord = UserRecord.fetch().first else { return FSPagerViewCell() }
        let fruitsInBook = chapterRecord.filter { $0.grade == index }
        let passedFruitsInBook = fruitsInBook.filter { $0.isPassed }
        // 100%가 아니면 색이 없는 표지. 100%이면 색이 들어간 표지. 승급심사까지 통과했으면 색이 들어간 표지에 도장까지.
        if userRecord[index] {
            cell.coverImageView.image = UIImage(named: imageNames[index][1])
            cell.stampImageView.image = #imageLiteral(resourceName: "stamp_clear")
        } else {
            if fruitsInBook.count == passedFruitsInBook.count {
                cell.coverImageView.image = UIImage(named: imageNames[index][1])
            } else {
                cell.coverImageView.image = UIImage(named: imageNames[index][0])
            }
            cell.stampImageView.image = nil
        }
        return cell
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
}

extension BookViewController: FSPagerViewDelegate {
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
        resetViews()
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        // 현재 등급과 교과서 등급을 비교하여 접근 제한
        let myGrade = UserRecord.fetch().first?.grade ?? 0
        if !(0...myGrade).contains(index) {
            UIAlertController.presentErrorAlert(to: self, error: "당신은 아직 \(Grade(rawValue: myGrade)?.expression ?? "")예요!")
            return
        }
        guard let next = UIViewController.instantiate(storyboard: "Chapter", identifier: ChapterViewController.classNameToString) as? ChapterViewController else { return }
        next.grade = index
        navigationController?.pushViewController(next, animated: true)
    }
}

// MARK: - UICollectionView DataSource Implementation
extension BookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? BookCell else { return UICollectionViewCell() }
        guard let userRecord = UserRecord.fetch().first else { return UICollectionViewCell() }
        let fruitsInBook = chapterRecord.filter { $0.grade == indexPath.item }
        let passedFruitsInBook = fruitsInBook.filter { $0.isPassed }
        // 100%가 아니면 색이 없는 표지. 100%이면 색이 들어간 표지. 승급심사까지 통과했으면 색이 들어간 표지에 도장까지.
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
// MARK: - UICollectionView Delegate Implementation
extension BookViewController: UICollectionViewDelegate {
    // 스크롤뷰의 스크롤 효과가 끝났음을 받는 델리게이트 메소드
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetViews()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // 현재 등급과 교과서 등급을 비교하여 접근 제한
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

// MARK: - Making Dynamic Views
private extension BookViewController {
    // 컬렉션뷰를 제외한 다른 모든 뷰를 다시 만듦
    func resetViews() {
        makeGaugeLabel()
        makePercentLabel()
        makeDescriptionLabel()
        makePromotionReviewButton()
    }
    // 달성률을 시각적으로 보여주는 게이지(레이블 활용하여 만듦)를 만듦
    func makeGaugeLabel() {
        // 달성률 구하기
        let filtered = chapterRecord.filter("grade = %d", pagerView.currentIndex)
        let count = filtered.count
        var passedCount = 0
        for element in filtered where element.isPassed {
            passedCount += 1
        }
        let percentage = CGFloat(passedCount) / CGFloat(count)
        self.percentage = percentage
        view.viewWithTag(gaugeLabelTag)?.removeFromSuperview()
        // 레이블 프로퍼티 설정
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .main
            label.tag = gaugeLabelTag
            label.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.737254902, blue: 0.7137254902, alpha: 1)
            label.layer.cornerRadius = backgroundGaugeView.bounds.height / 2
            label.clipsToBounds = true
            view.addSubview(label)
            return label
        }()
        label.snp.makeConstraints { maker in
            maker.height.equalTo(backgroundGaugeView.snp.height)
            maker.leading.equalTo(backgroundGaugeView.snp.leading)
            maker.centerY.equalTo(backgroundGaugeView.snp.centerY)
            maker.width.equalTo(backgroundGaugeView.snp.width).multipliedBy(percentage)
        }
        view.layoutIfNeeded()
    }
    // 달성률 표시하는 레이블 만들기
    func makePercentLabel() {
        // backgroundGaugeView의 슈퍼뷰와의 간격 구하여 percentLabel의 크기 적절하게 설정
        let leading = backgroundGaugeView.frame.origin.x
        view.viewWithTag(percentLabelTag)?.removeFromSuperview()
        percentLabel.tag = percentLabelTag
        view.addSubview(percentLabel)
        if percentage == 0 {
            percentLabel.snp.makeConstraints { maker in
                maker.top.equalTo(backgroundGaugeView.snp.bottom).offset(6)
                maker.centerX.equalTo(backgroundGaugeView.snp.leading)
            }
        } else {
            percentLabel.snp.makeConstraints { maker in
                maker.top.equalTo(backgroundGaugeView.snp.bottom).offset(6)
                maker.centerX.equalTo(backgroundGaugeView.snp.trailing)
                    .offset(leading - leading * percentage)
                    .multipliedBy(percentage)
            }
        }
        percentLabel.text = "\(Int(percentage * 100))%"
    }
    // 화면을 비어보이지 않게 하는 레이블 만들기
    func makeDescriptionLabel() {
        view.viewWithTag(descriptionLabelTag)?.removeFromSuperview()
        // 레이블 프로퍼티 설정
        let label: UILabel = {
            let label = UILabel()
            label.tag = descriptionLabelTag
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .main
            label.text = labelText()
            view.addSubview(label)
            return label
        }()
        label.snp.makeConstraints { maker in
            maker.centerX.equalTo(view.snp.centerX)
            maker.top.equalTo(percentLabel.snp.bottom).offset(8)
        }
    }
    // 승급심사 버튼 만들기
    func makePromotionReviewButton() {
        view.viewWithTag(promotionReviewButtonTag)?.removeFromSuperview()
        let passesCurrentBook = UserRecord.fetch().first?[pagerView.currentIndex] ?? false
        // 교과서 달성률이 100%이면 버튼 표시. 100%이나 승급심사를 통과했으면 버튼 표시하지 않음
        if percentage == 1 && !passesCurrentBook {
            // 버튼 프로퍼티 설정
            let button: UIButton = {
                let button = UIButton(type: .system)
                button.tag = promotionReviewButtonTag
                button.setTitle("승급 심사", for: [])
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                button.clipsToBounds = true
                button.layer.cornerRadius = button.bounds.height / 2
                button.layer.borderColor = UIColor.main.cgColor
                button.layer.borderWidth = 2
                button.addTarget(self, action: #selector(didTouchUpPromotionReviewButton(_:)), for: .touchUpInside)
                view.addSubview(button)
                return button
            }()
            button.snp.makeConstraints { maker in
                maker.top.equalTo(percentLabel.snp.bottom).offset(40)
                maker.width.equalTo(view.snp.width).multipliedBy(0.6)
                maker.centerX.equalTo(view.snp.centerX)
                maker.height.equalTo(40)
            }
            view.layoutIfNeeded()
            button.clipsToBounds = true
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }
}

private extension BookViewController {
    func labelText() -> String? {
        print(percentage)
        guard let userInfo = UserRecord.fetch().first else { return nil }
        let userGrade = userInfo.grade
        switch percentage {
        case 0:
            if userGrade == pagerView.currentIndex {
                return "자, 지금부터 과일 카드를 모아볼까?"
            } else if userGrade < pagerView.currentIndex {
                return "아직 당신에겐 수련이 필요하오."
            }
        case 0.5:
            return "벌써 반이나 모았다고? 조금만 더 힘을 내게!"
        case 0..<0.5, 0.5..<1:
            
            switch userGrade {
            case 0:
                return "훈장님이 되고싶개"
            case 1:
                return "훈장이 되고 싶소"
            case 2:
                return "나는 훈장이오 만렙이슈"
            default:
                break
            }
        case 1:
            if pagerView.currentIndex == 0 {
                if userInfo.passesDog {
                    return "드디어 사람이 되었개! 서당개 인생은 이제 안녕."
                } else {
                    return "당신은 이제 학도가 되기에 충분하개!"
                }
            } else if pagerView.currentIndex == 1 {
                if userInfo.passesStudent {
                    return "나도 어디서 꿀리지 않는 과일인이 되었소."
                } else {
                    return "나는 훈장님이 되러 떠나겠어!"
                }
            } else if pagerView.currentIndex == 2 {
                if userInfo.passesBoss {
                    return "과일학당 훈장이오. 무엇이든 물어보시오."
                } else {
                    return "앞으로도 많이 업데이트 할 예정이니 아직 지우지 말아주세요!"
                }
            }
        default:
            break
        }
        return nil
    }
}
