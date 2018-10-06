//
//  CommunityViewController.swift
//  FruitSchool
//
//  Created by Presto on 29/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cell = "communityCell"
    var communityListResponse: [CommunityListResponse.Data]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo_noncircle"))
        tableView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "communityCell")
        API.requestCommunityList { response, statusCode, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = response else { return }
            self.communityListResponse = data.data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}

extension CommunityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communityListResponse?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as? CommunityCell else { return UITableViewCell() }
        guard let communityListResponse = self.communityListResponse?[indexPath.row] else { return UITableViewCell() }
        cell.contentLabel.text = communityListResponse.content
        cell.nicknameLabel.text = communityListResponse.authorInfo.first?.nickname
        cell.likeButtom.setTitle(String(communityListResponse.likes) + " 좋아요", for: .normal)
        cell.replyButton.setTitle(String(communityListResponse.commentCount) + " 댓글", for: .normal)
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: communityListResponse.authorInfo.first?.profileImage ?? "") else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            DispatchQueue.main.async {
                cell.profileImageView.image = UIImage(data: imageData)
            }
        }
        
        //2018-10-06T19:24:44.000Z
        return cell
    }    
}
