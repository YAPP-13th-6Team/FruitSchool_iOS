//
//  FruitBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

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
    var currentCellIndex: Int = 0
    let imageNames = [["cover_dog_unclear", "cover_dog_clear"], ["cover_student_unclear", "cover_student_clear"], ["cover_boss_unclear", "cover_boss_clear"]]
    // 달성률을 표시하는 레이블은 전역 프로퍼티에 할당하여 사용
    var percentLabel: UILabel!
    @IBOutlet weak var backgroundGaugeView: UILabel!
    @IBOutlet weak var collectionView: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetViews()
        collectionView.reloadSections(IndexSet(0...0))
        collectionView.scrollToFirstItem()
    }
    
    private func setup() {
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
        
        // MARK: - Custom UICollectionViewFlowLayout Implementation
        let layout = PagingPerCellFlowLayout()
        let width = self.view.bounds.width * 0.7
        let height = width * 1.27
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.showsHorizontalScrollIndicator = false
    }
}
// MARK: - Button Touch Event
extension BookViewController {
    // 승급심사 버튼을 누르면 승급심사 뷰컨트롤러로 넘어감
    @objc func didTouchUpPromotionReviewButton(_ sender: UIButton) {
        guard let next = UIViewController.instantiate(storyboard: "PromotionReview", identifier: PromotionReviewContainerViewController.classNameToString) as? PromotionReviewContainerViewController else { return }
        next.delegate = self
        next.grade = currentCellIndex
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
                self.collectionView.reloadSections(IndexSet(0...0))
                self.resetViews()
            })
            .present(to: self)
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
        // 현재 보여지고 있는 컬렉션뷰의 셀 인덱스 구하기
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let index = collectionView.indexPathForItem(at: visiblePoint)?.item else { return }
        currentCellIndex = index
        // 달성률 구하기
        let filtered = chapterRecord.filter("grade = %d", index)
        let count = filtered.count
        var passedCount = 0
        for element in filtered where element.isPassed {
            passedCount += 1
        }
        let percentage = CGFloat(passedCount) / CGFloat(count)
        self.percentage = percentage
        view.viewWithTag(gaugeLabelTag)?.removeFromSuperview()
        // 레이블 프로퍼티 설정
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .main
        label.tag = gaugeLabelTag
        label.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.737254902, blue: 0.7137254902, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: backgroundGaugeView.heightAnchor),
            label.leadingAnchor.constraint(equalTo: backgroundGaugeView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: backgroundGaugeView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: backgroundGaugeView.widthAnchor, multiplier: percentage)
            ])
        view.layoutIfNeeded()
        // 레이블 외곽선 둥글게 만들기
        label.layer.cornerRadius = label.bounds.height / 2
        label.layer.masksToBounds = true
    }
    // 달성률 표시하는 레이블 만들기
    func makePercentLabel() {
        // backgroundGaugeView의 슈퍼뷰와의 간격 구하여 percentLabel의 크기 적절하게 설정
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
    // 화면을 비어보이지 않게 하는 레이블 만들기
    func makeDescriptionLabel() {
        view.viewWithTag(descriptionLabelTag)?.removeFromSuperview()
        // 레이블 프로퍼티 설정
        let label = UILabel()
        label.tag = descriptionLabelTag
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .main
        label.text = labelText()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 8)
            ])
    }
    // 승급심사 버튼 만들기
    func makePromotionReviewButton() {
        view.viewWithTag(promotionReviewButtonTag)?.removeFromSuperview()
        let passesCurrentBook = UserRecord.fetch().first?[currentCellIndex] ?? false
        // 교과서 달성률이 100%이면 버튼 표시. 100%이나 승급심사를 통과했으면 버튼 표시하지 않음
        if percentage == 1 && !passesCurrentBook {
            // 버튼 프로퍼티 설정
            let button = UIButton(type: .system)
            button.tag = promotionReviewButtonTag
            button.setTitle("승급 심사", for: [])
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            button.addTarget(self, action: #selector(didTouchUpPromotionReviewButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            // 오토레이아웃 설정
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: percentLabel.bottomAnchor, constant: 40),
                button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                //button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                //button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                button.heightAnchor.constraint(equalToConstant: 40)
                ])
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.borderColor = UIColor.main.cgColor
        }
    }
}

private extension BookViewController {
    func labelText() -> String? {
        guard let userInfo = UserRecord.fetch().first else { return nil }
        let userGrade = userInfo.grade
        switch percentage {
        case 0:
            if userGrade == currentCellIndex {
                return "자, 지금부터 과일 카드를 모아볼까?"
            } else if userGrade < currentCellIndex {
                return "아직 당신에겐 수련이 필요하오."
            }
        case 0..<50, 50..<100:
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
        case 50:
            return "벌써 반이나 모았다고? 조금만 더 힘을 내게!"
        case 100:
            if currentCellIndex == 0 {
                if userInfo.passesDog {
                    return "드디어 사람이 되었개! 서당개 인생은 이제 안녕."
                } else {
                    return "당신은 이제 학도가 되기에 충분하개!"
                }
            } else if currentCellIndex == 1 {
                if userInfo.passesStudent {
                    return "나도 어디서 꿀리지 않는 과일인이 되었소."
                } else {
                    return "나는 훈장님이 되러 떠나겠어!"
                }
            } else if currentCellIndex == 2 {
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
