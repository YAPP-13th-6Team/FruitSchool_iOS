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
        guard let url: URL = URL(string: "http://ec2-13-125-249-84.ap-northeast-2.compute.amazonaws.com:3000/posts/lists/sort/0") else { return }
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data, reponse, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let communityListResponse: CommunityListResponse = try JSONDecoder().decode(CommunityListResponse.self, from: data)
                self.communityListResponse = communityListResponse.data
                self.tableView.reloadData()
                
            } catch (let err) {
                print(err.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

extension CommunityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communityListResponse?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as? CommunityCell else { return UITableViewCell() }
        guard let communityListResponse = self.communityListResponse else { return UITableViewCell() }
        cell.contentLabel.text = communityListResponse.first?.content
        return cell
    }    
}
