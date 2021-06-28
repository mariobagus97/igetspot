//
//  UIButtonExtension.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 9/20/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

// UIButton extension from : https://github.com/mervynokm/UIButton-ImageAndTitlePositioning.git

extension UIButton {
    
    /// Enum to determine the title position with respect to the button image
    ///
    /// - top: title above button image
    /// - bottom: title below button image
    /// - left: title to the left of button image
    /// - right: title to the right of button image
    @objc enum Position: Int {
        case top, bottom, left, right
    }
    
    /// This method sets an image and title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, title: String, titlePosition: Position, additionalSpacing: CGFloat,state: State){
        imageView?.contentMode = .scaleAspectFit
        setImage(image, for: state)
        setTitle(title, for: state)
        titleLabel?.contentMode = .left
        
        adjust(title: title as NSString, at: titlePosition, with: additionalSpacing)
        
    }
    
    /// This method sets an image and an attributed title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button attributed title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: Position, width spacing: CGFloat, state: State){
        imageView?.contentMode = .scaleAspectFill
        setImage(image, for: state)
        
        adjust(attributedTitle: title, at: position, with: spacing)
        
        titleLabel?.contentMode = .left
        setAttributedTitle(title, for: state)
    }
    
    
    // MARK: Private Methods
    
    @objc private func adjust(title: NSString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    @objc private func adjust(attributedTitle: NSAttributedString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = attributedTitle.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    @objc private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: Position, withSpacing spacing: CGFloat) {
        switch (position) {
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: spacing / 2 + titleSize.height, left: -imageRect.width/2, bottom: 0, right: -imageRect.width/2)
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect.width/2, bottom: spacing / 2 + titleSize.height, right: -imageRect.width/2)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: spacing)
            imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -(spacing*2))
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 5, left: -40, bottom: 5, right: -100)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 30)
        }
    }

    
    func setTitle(_ title:String,spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: title.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}
