//
//  PushViewController.swift
//  ShapesInSpace
//
//  Created by Alexander Tikhonov on 20/07/15.
//  Copyright © 2015 Alexander Tikhonov. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    private var animator: UIDynamicAnimator!
    private var previousTouchPoint = CGPoint.zeroPoint

    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    private func configureViewController() {
        animator = UIDynamicAnimator(referenceView: view)
        
        let collision = UICollisionBehavior(items: [firstView,secondView])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let push = UIPushBehavior(items: [firstView,secondView], mode: UIPushBehaviorMode.Continuous)
        push.setAngle(CGFloat(Double(arc4random()%360)*M_PI/180.0), magnitude: CGFloat(0.3))
        push.setTargetOffsetFromCenter(UIOffsetMake(10, 10), forItem: firstView)
        push.setTargetOffsetFromCenter(UIOffsetMake(10, -10), forItem: secondView)
        animator.addBehavior(push)
    }
    
    @IBAction func dismissViewController() {
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }
}
