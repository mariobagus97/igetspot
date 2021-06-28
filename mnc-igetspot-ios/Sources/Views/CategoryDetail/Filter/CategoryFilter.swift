//
//  CategoryFilter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/17/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

class CategoryFilter: MessageView{
    
    var closeMessage: (() -> Void)?
    
    var applyFilter: (() -> Void)?
    
    @IBOutlet weak var lowerPriceLabel: UILabel!
    
    @IBOutlet weak var highestPriceLabel: UILabel!
    
    @IBOutlet weak var allStarView: UIView!
    
    @IBOutlet weak var oneStarView: UIView!
    
    @IBOutlet weak var twoStarView: UIView!
    
    @IBOutlet weak var threeStarView: UIView!
    
    @IBOutlet weak var fourStarView: UIView!
    
    @IBOutlet weak var fiveStarView: UIView!
    
    @IBOutlet weak var oneStarImage: UIImageView!
    
    @IBOutlet weak var twoStarImage : UIImageView!
    
    @IBOutlet weak var threeStarImage : UIImageView!
    
    @IBOutlet weak var fourStarImage : UIImageView!
    
    @IBOutlet weak var fiveStarImage : UIImageView!
    
    @IBOutlet weak var applyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        applyButton.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: applyButton.bounds.size.height/2)
        
        
        lowerPriceLabel.makeItRounded(width: 1.0, borderColor: UIColor.black.cgColor, cornerRadius: 3)
        
        highestPriceLabel.makeItRounded(width: 1.0, borderColor: UIColor.black.cgColor, cornerRadius: 3)
        
        allStarView.makeItRounded(width: 0.5, borderColor: UIColor.rgb(red: 151, green: 151, blue: 151).cgColor, cornerRadius: 5)
        
        oneStarView.makeItRounded(width: 0.5, borderColor: UIColor.rgb(red: 151, green: 151, blue: 151).cgColor, cornerRadius: 5)
        
        twoStarView.makeItRounded(width: 0.5, borderColor: UIColor.rgb(red: 151, green: 151, blue: 151).cgColor, cornerRadius: 5)
        
        threeStarView.makeItRounded(width: 0.5, borderColor: UIColor.rgb(red: 151, green: 151, blue: 151).cgColor, cornerRadius: 5)
        
        fourStarView.makeItRounded(width: 0.5, borderColor: UIColor.rgb(red: 151, green: 151, blue: 151).cgColor, cornerRadius: 5)
        
        fiveStarView.makeItRounded(width: 0.5, borderColor: UIColor.rgb(red: 151, green: 151, blue: 151).cgColor, cornerRadius: 5)
        
        
        addGesture()
    }
    
    func addGesture(){
        oneStarView.isUserInteractionEnabled = true
        oneStarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onOnePressed(_:))))
        
        twoStarView.isUserInteractionEnabled = true
        twoStarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onTwoPressed(_:))))
        
        threeStarView.isUserInteractionEnabled = true
        threeStarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onThreePressed(_:))))
        
        fourStarView.isUserInteractionEnabled = true
        fourStarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onFourPressed(_:))))
        
        fiveStarView.isUserInteractionEnabled = true
        fiveStarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onFivePressed(_:))))
    }
    
    
    @objc func onOnePressed(_ sender: UITapGestureRecognizer) {
        oneStarImage.setImageColor(color: UIColor.rgb(red: 248, green: 231, blue: 28))
    }
    
    @objc func onTwoPressed(_ sender: UITapGestureRecognizer) {
        twoStarImage.setImageColor(color: UIColor.rgb(red: 248, green: 231, blue: 28))
    }
    
    @objc func onThreePressed(_ sender: UITapGestureRecognizer) {
        threeStarImage.setImageColor(color: UIColor.rgb(red: 248, green: 231, blue: 28))
    }
    
    @objc func onFourPressed(_ sender: UITapGestureRecognizer) {
        fourStarImage.setImageColor(color: UIColor.rgb(red: 248, green: 231, blue: 28))
    }
    
    @objc func onFivePressed(_ sender: UITapGestureRecognizer) {
        fiveStarImage.setImageColor(color: UIColor.rgb(red: 248, green: 231, blue: 28))
    }
    
    @IBAction func onApplyPressed(_ sender: Any) {
        applyFilter?()
    }
    
    @IBAction func onClosePressed(_ sender: Any) {
        closeMessage?()
    }
    
}
