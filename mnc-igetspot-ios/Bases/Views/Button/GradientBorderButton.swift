//
//  GradientBorderButton.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 17/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class GradientBorderButton: UIButton {

    var colors: [UIColor] = [Colors.gradientThemeTwo, Colors.gradientThemeOne]
    var startPoint = CGPoint.zero
    var endPoint = CGPoint(x: 1, y: 0)
    private var cornerRadius: CGFloat = 0
    private var borderWidth: CGFloat = 0
    private var gradientLayer = CAGradientLayer()
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    internal func setupView() {
        
        gradientLayer.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map({ return $0.cgColor })
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 2.5, dy: 2.5), cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = nil
        gradientLayer.mask = shape
        
        self.layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupButton(colors: [UIColor] = [], startPoint: CGPoint = .zero, endPoint: CGPoint = CGPoint(x: 0, y: 0), cornerRadius:CGFloat) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.cornerRadius = cornerRadius
        setupView()
    }

}
