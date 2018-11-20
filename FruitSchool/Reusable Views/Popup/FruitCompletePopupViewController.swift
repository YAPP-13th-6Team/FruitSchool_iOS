//
//  FruitCompletePopupViewController.swift
//  
//
//  Created by Presto on 21/10/2018.
//

import UIKit
import SnapKit

class FruitCompletePopupViewController: UIViewController {

    var fruitImage: UIImage!
    var fruitTitle: String!
    var english: String!
    var grade: Int!
    var blurView: UIView!
    var handler: (() -> Void)?
    var lockImageView = UIImageView(image: #imageLiteral(resourceName: "lock"))
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = 15
            backgroundView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = UIImage(named: english.toImageName(grade: grade, isDetail: false))
            imageView.layer.cornerRadius = 4
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "\(fruitTitle ?? "") 학습완료!"
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = """
            Lv.\(grade + 1) \(Grade(rawValue: grade)?.expression ?? "")
            카드 \(fruitTitle ?? "")
            """
        }
    }
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            confirmButton.layer.cornerRadius = 15
            confirmButton.isEnabled = false
            confirmButton.addTarget(self, action: #selector(touchUpConfirmButton(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.blurView.alpha = 0
            self.lockImageView.alpha = 0
        }, completion: { _ in
            self.lockImageView.removeFromSuperview()
            self.blurView.removeFromSuperview()
            self.confirmButton.isEnabled = true
        })
    }
    
    @objc private func touchUpConfirmButton(_ sender: UIButton) {
        dismiss(animated: true) {
            self.handler?()
        }
    }
    
    func setUp() {
        let blurEffect = UIBlurEffect(style: .prominent)
        blurView = UIVisualEffectView(effect: blurEffect)
        imageView.addSubview(blurView)
        blurView.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.top)
            maker.leading.equalTo(imageView.snp.leading)
            maker.trailing.equalTo(imageView.snp.trailing)
            maker.bottom.equalTo(imageView.snp.bottom)
        }
        imageView.addSubview(lockImageView)
        lockImageView.snp.makeConstraints { maker in
            maker.center.equalTo(imageView.snp.center)
        }
    }
}
