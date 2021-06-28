//
//  ServicesHeaderView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ServicesHeaderDelegate{
    func deleteRows(row: Int)
    func addRows(row: Int)
    
}

class ServicesHeaderView: HeaderSectionView {
    
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var expandButton: UILabel!
    
    var isExpanded: Bool = true
    
    var row : Int!
    var headerDelegate: ServicesHeaderDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        serviceImageView.isSkeletonable = true
        serviceLabel.isSkeletonable = true
        
        serviceImageView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: serviceImageView.frame.width/2)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isPressed(_:))))
    }
    
    @objc func isPressed(_ sender: UITapGestureRecognizer){
        expandOrCollapse()
    }
    
    func setContent(image: String, name: String){
        
        serviceImageView.loadIGSImage(link: image)
        serviceLabel.text = name
        serviceLabel.textAlignment = .center
        expandOrCollapse()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func expandOrCollapse(){
        if (isExpanded){
            
            expandButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            
            self.isExpanded = false
            self.headerDelegate?.deleteRows(row: row)
        } else {
            
            expandButton.transform = CGAffineTransform(rotationAngle: 0)
            
            self.isExpanded = true
            self.headerDelegate?.addRows(row: row)
        }
    }
    
    func showLoadingView() {
        serviceImageView.showAnimatedGradientSkeleton()
        serviceLabel.showAnimatedGradientSkeleton()
        separatorView.alpha = 0.0
    }
    
    func hideLoadingView() {
        serviceImageView.hideSkeleton()
        serviceLabel.hideSkeleton()
        separatorView.alpha = 1.0
    }
    
}
