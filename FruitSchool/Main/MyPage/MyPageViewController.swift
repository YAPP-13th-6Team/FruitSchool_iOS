//
//  MyPageViewController.swift
//  FruitSchool
//
//  Created by Presto on 29/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit
import KakaoOpenSDK

class MyPageViewController: UIViewController {

    let cellIdentifiers = ["userInfoCell", "myPostCell", "myCommentCell", "myFavoritePostCell"]
    var userInfoResponse: UserInfoResponse.Data?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "생활기록부"
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestUserInfo { response, statusCode, error in
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
            self.userInfoResponse = response.data.first
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                
            }
        }
        self.tableView.tableFooterView = UIView()
    }
}
    
extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[section], for: indexPath)
        switch section {
        case 0:
            (cell as? UserInfoCell)?.setProperties(userInfoResponse)
        case 1:
            (cell as? MyPostCell)?.setProperties()
        case 2:
            (cell as? MyCommentCell)?.setProperties()
        case 3:
            (cell as? MyFavoritePostCell)?.setProperties()
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        default:
            return 44
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        default:
            break
        }
    }
}
