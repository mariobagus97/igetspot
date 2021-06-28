//
//  CustomIndicatorActivityView.swift
//  mnc-igetspot-ios
//
//  Created by Mendhy Syiasko on 08/07/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit

class CustomIndicatorActivityView: UIView {
    
    /// A flag indicating the animation state of the `InputBarSendButton`
    open private(set) var isAnimating: Bool = false
    
    /// Accessor to modify the color of the activity view
    open var activityViewColor: UIColor! {
        get {
            return activityView.color
        }
        set {
            activityView.color = newValue
        }
    }
    
    private let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSendButton()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSendButton()
    }
    
    private func setupSendButton() {
        addSubview(activityView)
        activityView.snp_makeConstraints { make in
            make.top.left.bottom.right.equalTo(self)
        }
    }
    
    /// Starts the animation of the activity view, hiding other elements
    open func startAnimating() {
        guard !isAnimating else { return }
        defer { isAnimating = true }
        activityView.startAnimating()
        activityView.isHidden = false
        }
    
    /// Stops the animation of the activity view, shows other elements
    open func stopAnimating() {
        guard isAnimating else { return }
        defer { isAnimating = false }
        activityView.stopAnimating()
        activityView.isHidden = true
    }
    
    
}

