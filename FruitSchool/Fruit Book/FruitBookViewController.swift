//
//  FruitBookViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class FruitBookViewController: UIViewController {

    var searchBar = UISearchBar()
    var searchButton: UIBarButtonItem!
    @IBOutlet weak var circle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(touchUpSearchButton(_:)))
        searchBar.delegate = self
        navigationItem.setRightBarButton(searchButton, animated: true)
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanCircle(_:))))
    }
    
    @objc func didPanCircle(_ gesture: UIPanGestureRecognizer) {
        let middlePointOfSuperView = CGPoint(x: 100, y: 100)
        let radius: CGFloat = 100
        let theta: CGFloat = .pi / 6
        let minimumX = middlePointOfSuperView.x - radius * cos(theta)
        let maximumX = middlePointOfSuperView.x + radius * cos(theta)
        let locationX = gesture.location(in: circle.superview).x
        switch locationX {
        case minimumX...maximumX:
            circle.center.x = locationX
            circle.center.y = {
                return middlePointOfSuperView.y - sqrt(pow(radius, 2) - pow(radius - locationX, 2))
            }()
        default:
            break
        }
    }
    
    @objc func touchUpSearchButton(_ sender: UIBarButtonItem) {
        searchBar.becomeFirstResponder()
        navigationItem.setRightBarButton(nil, animated: true)
        navigationItem.titleView = searchBar
    }
}

extension FruitBookViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.titleView = nil
        navigationItem.setRightBarButton(searchButton, animated: true)
    }
}
