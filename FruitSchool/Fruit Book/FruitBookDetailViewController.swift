//
//  FruitBookDetailViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class FruitBookDetailViewController: UIViewController {
    
    @IBOutlet weak var superview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let gravityCenter = CGPoint(x: (topMiddlePoint.x + bottomLeftPoint.x + bottomRightPoint.x) / 3, y: (topMiddlePoint.y + bottomLeftPoint.y + bottomRightPoint.y) / 3)
        
        let view = TriangleView(frame: superview.bounds)
        superview.addSubview(view)
    }
}
