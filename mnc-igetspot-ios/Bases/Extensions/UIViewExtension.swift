//
//  UIViewExtension.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 11/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit
import SnapKit
import SwiftMessages

extension UIView {
    
    enum VerticalLocation: String {
        case bottom
        case top
    }
    
    var safeArea: ConstraintBasicAttributesDSL {
        
        #if swift(>=3.2)
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
        #else
        return self.snp
        #endif
    }
    
    func xibSetup() {
        let view = loadFromNib()
        addSubview(view)
        stretch(view: view)
    }
    
    func loadFromNib<T: UIView>() -> T {
        let selfType = type(of: self)
        let bundle = Bundle(for: selfType)
        let nibName = String(describing: selfType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Error loading nib with name \(nibName)")
        }
        
        return view
    }
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func stretch(view: UIView) {
        view.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self)
        }
    }
    
    func makeItRounded(width: CGFloat = 1, borderColor: CGColor = UIColor.black.cgColor, cornerRadius: CGFloat = 2){
        self.layer.borderWidth = width
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func setRounded() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func elevate(elevation: Double, location: VerticalLocation = .bottom) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        switch location {
        case .bottom:
            self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        case .top:
            self.layer.shadowOffset = CGSize(width: 0, height: -elevation)
        }
        
        self.layer.shadowRadius = CGFloat(elevation)
        self.layer.shadowOpacity = 0.24
    }
    
    func makeGradient(view: UIView, color: [UIColor]) {
//        var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 35))
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.bounds.size
        gradientLayer.colors = color
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.addSublayer(gradientLayer)
    }
    
    func makeTextFieldBlank(textfield: UITextField){
        textfield.text = ""
    }
    
    func hideLabel(label: UILabel){
        label.isHidden = true
    }
    
    func showLabel(label: UILabel){
        label.isHidden = false
    }
    
    func randomIntNumber(min: Int, max: Int) -> Int{
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func showShouldSignIn(){
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Hey There!", body: "Please try swiping to dismiss this message.", iconImage: nil, iconText: "🦄", buttonImage: nil, buttonTitle: "No Thanks") { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: .statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    public func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}

extension ConstraintMaker {
    public func aspectRatio(_ x: Int, by y: Int, self instance: ConstraintView) {
        self.width.equalTo(instance.snp.height).multipliedBy(x / y)
    }
}
