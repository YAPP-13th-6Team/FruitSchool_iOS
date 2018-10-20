//
//  FruitCompletePopupViewController.swift
//  
//
//  Created by Presto on 21/10/2018.
//

import UIKit

class FruitCompletePopupViewController: UIViewController {

    var fruitImage: UIImage!
    var fruitTitle: String!
    var grade: Int!
    var blurView: UIView!
    var lockImageView: UIImageView!
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
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseInOut, animations: {
            self.blurView.alpha = 0
            self.lockImageView.alpha = 0
        }) { _ in
            self.lockImageView.removeFromSuperview()
            self.blurView.removeFromSuperview()
            self.confirmButton.isEnabled = true
        }
    }
    
    @objc func confirmButtonDidTouchUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        confirmButton.layer.cornerRadius = 15
        confirmButton.isEnabled = false
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        imageView.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: imageView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
            ])
        lockImageView = UIImageView(image: #imageLiteral(resourceName: "lock"))
        blurView.addSubview(lockImageView)
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lockImageView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            lockImageView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor)
            ])
        confirmButton.addTarget(self, action: #selector(confirmButtonDidTouchUp(_:)), for: .touchUpInside)
    }
}
