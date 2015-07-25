//
//  SpaceBackgroundView.swift
//  ShapesInSpace
//
//  Created by Tikhonov on 19/07/15.
//  Copyright © 2015 Alexander Tikhonov. All rights reserved.
//

import UIKit

class SpaceBackgroundView: UIView {
    
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var push: UIPushBehavior!
    private var dynamic: UIDynamicItemBehavior!
    private var collision: UICollisionBehavior!
    
    var numberRectangles: Int!
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        configureView()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func configureView() {
        animator = UIDynamicAnimator(referenceView: self)
        
        let blankView = UIView(frame: CGRectMake(0, 0, 1, 1))
        self.addSubview(blankView)
        
        //  let gravity = addGravityBehaviorForItems([blankView])
        dynamic = addDynamicBehaviorForItems([blankView])
        collision = addCollisionBehaviorForItems([blankView], view: self)
    }
    
    private func generateRects(point: CGPoint, side: CGFloat, color: UIColor) {
        var rectItems: Array<UIView> = []
        for _ in 1...numberRectangles {
            let square = UIView(frame:  CGRect(x: point.x, y: point.y, width: side, height: side))
            square.backgroundColor = color
            self.addSubview(square)
            rectItems.append(square)
            addItem(square)
        }
        
        let push = addPushBehaviorForItems(rectItems)
        
        let duration: NSTimeInterval = 1.5
        UIView.animateWithDuration(duration, animations: { () -> Void in
            rectItems.map({$0.alpha = 0})
            }) { (finished) -> Void in
                rectItems.map({ (view) -> UIView in
                    self.removeItem(view)
                    view.removeFromSuperview()
                    return view
                })
                self.animator.removeBehavior(push)
        }
    }
    
    private func addItem(view: UIView) {
        dynamic.addItem(view)
//        dynamic.addLinearVelocity(CGPointMake(0, CGFloat(arc4random()%100)), forItem: view)
//        dynamic.addAngularVelocity(1.1, forItem: view)
        
        //  gravity.addItem(view)
        collision.addItem(view)
    }
    private func removeItem(view: UIView) {
        dynamic.removeItem(view)
        //  gravity.removeItem(view)
        collision.removeItem(view)
    }
    
    private func addDynamicBehaviorForItems(items: Array<UIView>) -> UIDynamicItemBehavior {
        let dynamic = UIDynamicItemBehavior(items: items)
        dynamic.elasticity = 0.0
        if #available(iOS 9.0, *) {
            dynamic.charge = 2
        }
        dynamic.friction = 5
        dynamic.resistance = 1.0
        dynamic.angularResistance = 1.0
        //  for view in items {
        //  dynamic.addLinearVelocity(CGPointMake(0, CGFloat(arc4random()%3)), forItem: view)
        //  dynamic.addAngularVelocity(1.1, forItem: view)
        //  }
        animator.addBehavior(dynamic)
        return dynamic
    }
    
    private func addGravityBehaviorForItems(items: Array<UIView>) -> UIGravityBehavior {
        let gravity = UIGravityBehavior(items: items)
        let randomAngle = Double(arc4random()%180)*M_PI/180.0
        gravity.setAngle(CGFloat(randomAngle), magnitude: 1)
        animator.addBehavior(gravity)
        return gravity
    }
    
    private func addPushBehaviorForItems(items: Array<UIView>) -> UIPushBehavior {
        let push = UIPushBehavior(items: items, mode: UIPushBehaviorMode.Instantaneous)
        let powerDirection: CGFloat = 350.0
        let randomSign: CGFloat = (Double(arc4random()) / Double(UINT32_MAX)) > 0.5 ? 1 : -1
        let x = randomSign * CGFloat(Double(arc4random()) / Double(UINT32_MAX))/powerDirection
        let y = randomSign * CGFloat(Double(arc4random()) / Double(UINT32_MAX))/powerDirection
        push.pushDirection = CGVectorMake(x, y)
        push.magnitude = 0.0005
        animator.addBehavior(push)
        return push
    }
    
    private func addCollisionBehaviorForItems(items: Array<UIView>, view: UIView) -> UICollisionBehavior{
        let collision = UICollisionBehavior(items: items)
        collision.collisionDelegate = self
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundaryWithIdentifier("square", forPath: UIBezierPath(rect: view.frame))
        animator.addBehavior(collision)
        return collision
    }
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.locationInView(gestureRecognizer.view)
        generateRects(location, side: 10, color: UIColor.yellowColor())
    }
}

extension SpaceBackgroundView: UICollisionBehaviorDelegate {
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        let view = item as! UIView
        view.backgroundColor = UIColor.redColor()
        UIView.animateWithDuration(0.5) { () -> Void in
            view.backgroundColor = UIColor.yellowColor()
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        let view1 = item1 as! UIView
        let view2 = item2 as! UIView
        view1.backgroundColor = UIColor.redColor()
        view2.backgroundColor = UIColor.redColor()
        UIView.animateWithDuration(0.5) { () -> Void in
            view1.backgroundColor = UIColor.yellowColor()
            view2.backgroundColor = UIColor.yellowColor()
        }
    }
}
