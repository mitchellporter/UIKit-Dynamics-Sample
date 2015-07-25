//
//  SnapViewController.swift
//  ShapesInSpace
//
//  Created by Alexander Tikhonov on 20/07/15.
//  Copyright © 2015 Alexander Tikhonov. All rights reserved.
//

import UIKit

class SnapViewController: UIViewController {

    private var animator: UIDynamicAnimator!
    private var previousTouchPoint = CGPoint.zeroPoint
    private var draggingView = false
    private var snap: UISnapBehavior!
    
    @IBOutlet weak var firstView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    private func configureViewController() {
        animator = UIDynamicAnimator(referenceView: view)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        firstView.addGestureRecognizer(pan)
        snap = UISnapBehavior(item: firstView, snapToPoint: CGPointMake(200, 200))
        snap.damping = 1
        animator.addBehavior(snap)
    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.locationInView(view)
        let draggedView = gesture.view
        
        if gesture.state == UIGestureRecognizerState.Began {
            draggingView = true
            previousTouchPoint = touchPoint
            animator.removeBehavior(snap)
        } else if gesture.state == UIGestureRecognizerState.Changed && draggingView {
            draggedView?.center = CGPointMake((draggedView?.center.x)! - previousTouchPoint.x + touchPoint.x,
                (draggedView?.center.y)! - previousTouchPoint.y + touchPoint.y)
            previousTouchPoint = touchPoint
        } else if gesture.state == UIGestureRecognizerState.Ended && draggingView {
            draggingView = false
            animator.updateItemUsingCurrentState(draggedView!)
            snap = UISnapBehavior(item: firstView, snapToPoint: CGPointMake(200, 200))
            snap.damping = 1
            animator.addBehavior(snap)
        }
    }
    
    @IBAction func dismissViewController() {
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }

}
