//
//  AttachmentViewController.swift
//  ShapesInSpace
//
//  Created by Alexander Tikhonov on 20/07/15.
//  Copyright © 2015 Alexander Tikhonov. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController {
    
    private var animator: UIDynamicAnimator!
    private var previousTouchPoint = CGPoint.zeroPoint
    private var draggingView = false
    
    private var attachment: UIAttachmentBehavior!
    private var collision: UICollisionBehavior!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    private func configureViewController() {
        animator = UIDynamicAnimator(referenceView: view)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        firstView.addGestureRecognizer(pan)
        
        attachment = UIAttachmentBehavior(item: firstView, attachedToItem: secondView)
        attachment.damping = 0.8
        attachment.length = 10
        attachment.frequency = 0.3
        animator.addBehavior(attachment)
        
        collision = UICollisionBehavior(items: [firstView,secondView])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.locationInView(view)
        let draggedView = gesture.view
        
        if gesture.state == UIGestureRecognizerState.Began {
            draggingView = true
            previousTouchPoint = touchPoint
            animator.removeBehavior(attachment)
            animator.removeBehavior(collision)
        } else if gesture.state == UIGestureRecognizerState.Changed && draggingView {
            draggedView?.center = CGPointMake((draggedView?.center.x)! - previousTouchPoint.x + touchPoint.x,
                (draggedView?.center.y)! - previousTouchPoint.y + touchPoint.y)
            previousTouchPoint = touchPoint
        } else if gesture.state == UIGestureRecognizerState.Ended && draggingView {
            draggingView = false
            animator.updateItemUsingCurrentState(draggedView!)
            
            attachment = UIAttachmentBehavior(item: firstView, attachedToItem: secondView)
            attachment.damping = 0.8
            attachment.length = 10
            attachment.frequency = 0.3
            animator.addBehavior(attachment)

            collision = UICollisionBehavior(items: [firstView,secondView])
            collision.translatesReferenceBoundsIntoBoundary = true
            animator.addBehavior(collision)
        }
    }
    
    @IBAction func dismissViewController() {
        self.dismissViewControllerAnimated(true) { () -> Void in }
    }
    
}
