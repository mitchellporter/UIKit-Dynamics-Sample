//
//  SpaceViewController.swift
//  ShapesInSpace
//
//  Created by Tikhonov on 18/07/15.
//  Copyright © 2015 Alexander Tikhonov. All rights reserved.
//

import UIKit

class SpaceViewController: UIViewController {
    
    var spaceBackground: SpaceBackgroundView!
    var numberRectangles: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    private func configureViewController() {
        view.opaque = false
        spaceBackground = SpaceBackgroundView(frame: view.bounds)
        spaceBackground.numberRectangles = self.numberRectangles
        view.addSubview(spaceBackground)
        view.sendSubviewToBack(spaceBackground)
        spaceBackground.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
    }
    

    @IBAction func dismissViewController() {
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }
}

