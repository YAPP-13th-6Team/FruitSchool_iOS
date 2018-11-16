//
//  DetailViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var nth: Int = 0
    var id: String = ""
    var fruitResponse: FruitResponse.Data?
    var dummyView: UIView!
    let statusBar: UIView = (UIApplication.shared.value(forKey: "statusBar") as? UIView)!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        dummyView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: -66, left: 0, bottom: 0, right: 0)
        view.addSubview(dummyView)
        requestFruitDetails()
    }
    
    // 스크롤시 네비바 불투명하게
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / 200
        if offset > 1 {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationController?.navigationBar.backgroundColor = .white
                self.statusBar.backgroundColor = .white
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationController?.navigationBar.backgroundColor = .clear
                self.statusBar.backgroundColor = .clear
                })
        }
    }
    
    // 과일 세부 정보 요청하기
    private func requestFruitDetails() {
        IndicatorView.shared.showIndicator()
        API.requestFruit(by: id) { response, _, error in
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
            self.fruitResponse = response.data.first
            DispatchQueue.main.async { [weak self] in
                self?.dummyView.removeFromSuperview()
                self?.tableView.reloadData()
            }
        }
    }
}
// MARK: - UITableView DataSource Implementation
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell", for: indexPath) as? DetailImageCell
            (cell as? DetailImageCell)?.setProperties(fruitResponse, at: nth)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "detailSeasonCell", for: indexPath)
            let season = fruitResponse?.season ?? ""
            let text = "\(fruitResponse?.title ?? "")의 제철은 \(season) 입니다."
            let range = (text as NSString).range(of: season)
            let attributedString = NSMutableAttributedString(string: text, attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .ultraLight),
                .foregroundColor: #colorLiteral(red: 0.3254901961, green: 0.2784313725, blue: 0.2549019608, alpha: 1)
                ])
            let seasonAttribute: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: #colorLiteral(red: 0.3254901961, green: 0.2784313725, blue: 0.2549019608, alpha: 1)
            ]
            attributedString.addAttributes(seasonAttribute, range: range)
            cell?.textLabel?.attributedText = attributedString
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "detailTitleAndContentCell", for: indexPath) as? DetailStandardTipCell
            if indexPath.section == 2 {
                cell?.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            }
            (cell as? DetailStandardTipCell)?.setProperties(fruitResponse, for: indexPath)
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "detailNutritionTipCell", for: indexPath) as? DetailNutritionTipCell
            cell?.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            (cell as? DetailNutritionTipCell)?.setProperties(fruitResponse?.nutritionTip)
        default:
            cell = UITableViewCell()
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return fruitResponse?.standardTip.validCount ?? 0
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}
// MARK: - UITableView Delegate Implementation
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        if section == 0 || section == 1 {
            headerView.backgroundColor = .white
            return headerView
        } else if section == 3 {
            headerView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            return headerView
        }
        headerView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        let titleLabel = UILabel()
        titleLabel.textColor = #colorLiteral(red: 0.7098039216, green: 0.662745098, blue: 0.6392156863, alpha: 1)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16)
            ])
        if section == 2 {
            titleLabel.text = "기본정보"
        } else if section == 3 {
            titleLabel.text = ""
        }
        let line = UILabel()
        line.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8862745098, blue: 0.862745098, alpha: 1)
        headerView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            line.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            line.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            line.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 18),
            line.heightAnchor.constraint(equalToConstant: 1)
            ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        if section == 1 {
            footerView.backgroundColor = .white
        } else {
            footerView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section != 0 else { return view.bounds.width }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 10
        case 2:
            return 60
        default:
            return .leastNonzeroMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 10
        case 2:
            return 20
        default:
            return .leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
