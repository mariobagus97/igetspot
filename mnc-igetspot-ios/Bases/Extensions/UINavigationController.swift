//
//  UINavigationController.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/4/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

extension UINavigationController:UINavigationControllerDelegate{
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: self.interactivePopGestureRecognizer)) {
            if viewControllers.count > 1 {
                interactivePopGestureRecognizer?.isEnabled = true
            } else {
                interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }

    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
    func replaceViewController(with viewController: UIViewController, animated: Bool) {
        var vcs = viewControllers
        vcs = [viewController]
        setViewControllers(vcs, animated: animated)
    }
    
    /**
     Pop current view controller to previous view controller.
     
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func pop(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.popViewController(animated: false)
    }
    
    /**
     Push a new view controller on the view controllers's stack.
     
     - parameter vc:       view controller to push.
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func push(viewController vc: UIViewController, transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, duration: duration)
        self.pushViewController(vc, animated: false)
    }
    
    private func addTransition(transitionType type: CATransitionType = .fade, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = type
        self.view.layer.add(transition, forKey: nil)
    }
}
