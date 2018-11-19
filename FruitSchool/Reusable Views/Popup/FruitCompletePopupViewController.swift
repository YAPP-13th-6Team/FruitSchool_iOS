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
    var lockImageView: UIImageView!
    var handler: (() -> Void)?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    @objc func confirmButtonDidTouchUp(_ sender: UIButton) {
        dismiss(animated: true) {
            self.handler?()
        }
    }
    
    func setup() {
        guard let fruitTitle = fruitTitle, let grade = grade else { return }
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        confirmButton.layer.cornerRadius = 15
        confirmButton.isEnabled = false
        titleLabel.text = "\(fruitTitle) 학습완료!"
        imageView.image = UIImage(named: english.toImageName(grade: grade, isDetail: false))
        descriptionLabel.text = """
        Lv.\(grade + 1) \(Grade(rawValue: grade)?.expression ?? "")
        카드 \(fruitTitle)
        """
        let blurEffect = UIBlurEffect(style: .prominent)
        blurView = UIVisualEffectView(effect: blurEffect)
        imageView.addSubview(blurView)
        blurView.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.top)
            maker.leading.equalTo(imageView.snp.leading)
            maker.trailing.equalTo(imageView.snp.trailing)
            maker.bottom.equalTo(imageView.snp.bottom)
        }
        lockImageView = UIImageView(image: #imageLiteral(resourceName: "lock"))
        imageView.addSubview(lockImageView)
        lockImageView.snp.makeConstraints { maker in
            maker.center.equalTo(imageView.snp.center)
        }
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTouchUp(_:)), for: .touchUpInside)
    }
}
