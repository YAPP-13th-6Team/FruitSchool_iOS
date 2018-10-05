//
//  DetailViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var id: String = ""
    var fruit: FruitResponse.Data?
    let cellIdentifiers = ["detailImageCell", "detailStandardTipCell", "detailIntakeTipCell", "detailNutritionTipCell", "detailQuizCell"]
    let sectionTitles = ["기본 정보", "섭취 정보", "영양 정보"]
    var springsStandardTipSection: Bool = false
    var springsIntakeTipSection: Bool = false
    var springsNutritionTipSection: Bool = false
    var standardTipButton: UIButton!
    var intakeTipButton: UIButton!
    var nutritionTipButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestFruit(by: id) { response, statusCode, error in
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
            self.fruit = response.data.first
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
// MARK: - Button Touch Event
extension DetailViewController {
    @objc func touchUpHeaderButtons(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            springsStandardTipSection = !springsStandardTipSection
        case 2:
            springsIntakeTipSection = !springsIntakeTipSection
        case 3:
            springsNutritionTipSection = !springsNutritionTipSection
        default:
            break
        }
        tableView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[section], for: indexPath)
        switch section {
        case 0:
            (cell as? DetailImageCell)?.setProperties(fruit)
        case 1:
            (cell as? DetailStandardTipCell)?.setProperties(fruit?.standardTip, at: indexPath.row)
        case 2:
            (cell as? DetailIntakeTipCell)?.setProperties(fruit?.intakeTip, at: indexPath.row)
        case 3:
            (cell as? DetailNutritionTipCell)?.setProperties(fruit?.nutritionTip)
        case 4:
            (cell as? DetailQuizCell)?.setProperties(fruit?.quizs)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1 where springsStandardTipSection:
            return fruit?.standardTip.validCount ?? 0
        case 2 where springsIntakeTipSection:
            return fruit?.intakeTip.validCount ?? 0
        case 3 where springsNutritionTipSection:
            return 1
        case 4:
            return 1
        default:
            break
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 4 { return nil }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        view.backgroundColor = .white
        let titleLabel = UILabel()
        let dropButton = UIButton(type: .system)
        view.addSubview(titleLabel)
        view.addSubview(dropButton)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dropButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dropButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dropButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            ])
        dropButton.tag = section
        titleLabel.text = sectionTitles[section - 1]
        dropButton.setTitle("not selected", for: .normal)
        dropButton.setTitle("selected", for: .selected)
        dropButton.addTarget(self, action: #selector(touchUpHeaderButtons(_:)), for: .touchUpInside)
        switch section {
        case 1:
            standardTipButton = dropButton
            standardTipButton.isSelected = springsStandardTipSection
        case 2:
            intakeTipButton = dropButton
            intakeTipButton.isSelected = springsIntakeTipSection
        case 3:
            nutritionTipButton = dropButton
            nutritionTipButton.isSelected = springsNutritionTipSection
        default:
            break
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        case 1, 2:
            return UITableViewAutomaticDimension
        case 3:
            return 269
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 4 { return .leastNonzeroMagnitude }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
