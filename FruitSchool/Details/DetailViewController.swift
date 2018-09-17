//
//  DetailViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

enum DetailParentType {
    case fruitBook
    case guideBook
}

class DetailViewController: UIViewController {

    var parentType: DetailParentType = .fruitBook
    let cellIdentifiers = ["detailImageCell", "detailBasicInfoCell", "detailHealthInfoCell", "detailTriangleCell", "detailQuizCell"]
    var basicInfoButton: UIButton!
    var healthInfoButton: UIButton!
    var triangleInfoButton: UIButton!
    var springsBasicInfo: Bool = false
    var springsHealthInfo: Bool = false
    var springsTriangleInfo: Bool = false
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @objc func touchUpHeaderButtons(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            springsBasicInfo = !springsBasicInfo
        case 2:
            springsHealthInfo = !springsHealthInfo
        case 3:
            springsTriangleInfo = !springsTriangleInfo
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
            (cell as? DetailImageCell)?.setProperties()
        case 1:
            (cell as? DetailBasicInfoCell)?.setProperties()
        case 2:
            (cell as? DetailHealthInfoCell)?.setProperties()
        case 3:
            (cell as? DetailTriangleCell)?.setProperties()
        case 4:
            (cell as? DetailQuizCell)?.setProperties()
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if springsBasicInfo {
                return 3
            }
        case 2:
            if springsHealthInfo {
                return 3
            }
        case 3:
            if springsTriangleInfo {
                return 1
            }
        case 4:
            return 1
        default:
            break
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch parentType {
        case .fruitBook:
            return 5
        case .guideBook:
            return 4
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 4 { return nil }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
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
        titleLabel.text = "Section \(section)"
        dropButton.setTitle("not selected", for: .normal)
        dropButton.setTitle("selected", for: .selected)
        dropButton.addTarget(self, action: #selector(touchUpHeaderButtons(_:)), for: .touchUpInside)
        switch section {
        case 1:
            basicInfoButton = dropButton
            basicInfoButton.isSelected = springsBasicInfo
        case 2:
            healthInfoButton = dropButton
            healthInfoButton.isSelected = springsHealthInfo
        case 3:
            triangleInfoButton = dropButton
            triangleInfoButton.isSelected = springsTriangleInfo
        default:
            break
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 4 { return .leastNonzeroMagnitude }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
