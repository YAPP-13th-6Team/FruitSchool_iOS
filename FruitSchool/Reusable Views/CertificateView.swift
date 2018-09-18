//
//  CertificateView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol CertificateViewDelegate: class {
    
}

class CertificateView: UIView {
    
    weak var delegate: CertificateViewDelegate?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
