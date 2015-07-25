//
//  ViewController.swift
//  ShapesInSpace
//
//  Created by Tikhonov on 18/07/15.
//  Copyright © 2015 Alexander Tikhonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    private func configureViewController() {
        counterLabel.text = "0"
        stepper.maximumValue = 3
        
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        counterLabel.text = Int(stepper.value).description
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSpace" {
            if let spaceVC = segue.destinationViewController as? SpaceViewController {
                spaceVC.numberRectangles = Int(self.stepper.value)
            }
        }
    }
}


