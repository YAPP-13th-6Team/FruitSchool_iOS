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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo_noncircle"))
    }
}
    
extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[section], for: indexPath) as? UserInfoCell else { return UITableViewCell() }

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[section], for: indexPath) as? MyPostCell else { return UITableViewCell() }
            return cell
     
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[section], for: indexPath) as? MyCommentCell else { return UITableViewCell() }
            return cell
         
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[section], for: indexPath) as? MyFavoritePostCell else { return UITableViewCell() }
            return cell
            
        default:
            return UITableViewCell()
        }
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
