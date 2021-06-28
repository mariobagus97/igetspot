//
//  UIButton+Closure.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 17/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit

typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

extension UIButton {
    
    fileprivate struct AssociatedKeys {
        static var touchUpInsideClosure = "targetClosure"
    }
    
    fileprivate var touchUpInsideClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.touchUpInsideClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.touchUpInsideClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func onTouchUpInside(_ closure: @escaping UIButtonTargetClosure) {
        touchUpInsideClosure = closure
        addTarget(self, action: #selector(UIButton.touchUpInsideAction), for: .touchUpInside)
    }
    
    @objc
    fileprivate func touchUpInsideAction() {
        guard let touchUpInsideClosure = touchUpInsideClosure else { return }
        touchUpInsideClosure(self)
    }
}
