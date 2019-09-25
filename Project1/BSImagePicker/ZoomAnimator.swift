//
//  ZoomAnimator.swift
//  Project1
//
//  Created by Yujin Robot on 19/09/2019.
//  Copyright © 2019 Yujinrobot. All rights reserved.
//

import Foundation
import BSImageView


class ZoomAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    var sourceImageView: UIImageView?
    var destinationImageView: UIImageView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get to and from view controller
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to), let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let sourceImageView = sourceImageView, let destinationImageView = destinationImageView{
            let containerView = transitionContext.containerView
            // Disable selection so we don't select anything while the push animation is running
            fromViewController.view?.isUserInteractionEnabled = false
            
            // Setup views
            sourceImageView.isHidden = true
            destinationImageView.isHidden = true
            toViewController.view.alpha = 0.0
            fromViewController.view.alpha = 1.0
            containerView.backgroundColor = toViewController.view.backgroundColor
            
            // Setup scaling image
            let scalingFrame = containerView.convert(sourceImageView.frame, from: sourceImageView.superview)
            let scalingImage = BSImageView(frame: scalingFrame)
            scalingImage.contentMode = sourceImageView.contentMode
            scalingImage.image = sourceImageView.image
            scalingImage.clipsToBounds = true
            
            //Init image scale
            let destinationFrame = toViewController.view.convert(destinationImageView.bounds, from: destinationImageView.superview)
            
            // Add views to container view
            containerView.addSubview(toViewController.view)
            containerView.addSubview(scalingImage)
            
            // Animate
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0.0,
                           options: UIView.AnimationOptions(),
                           animations: { () -> Void in
                            // Fade in
                            fromViewController.view.alpha = 0.0
                            toViewController.view.alpha = 1.0
                            
                            scalingImage.frame = destinationFrame
                            scalingImage.contentMode = destinationImageView.contentMode
            }, completion: { (finished) -> Void in
                scalingImage.removeFromSuperview()
                
                // Unhide
                destinationImageView.isHidden = false
                sourceImageView.isHidden = false
                fromViewController.view.alpha = 1.0
                
                // Finish transition
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                
                // Enable selection again
                fromViewController.view?.isUserInteractionEnabled = true
            })
        }
    }
}
