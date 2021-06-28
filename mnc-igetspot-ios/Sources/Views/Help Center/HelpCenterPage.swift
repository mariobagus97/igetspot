//
//  HelpCenterPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/15/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol HelpCenterPageDelegate {
    func onContactUsPressed()
}

class HelpCenterPage: UIView {
    
    var delegate : HelpCenterPageDelegate!
    
    @IBOutlet weak var usingIgetSpotView: UIView!
    
    @IBOutlet weak var managingAccountView: UIView!
    
    @IBOutlet weak var privacyView: UIView!
    
    @IBOutlet weak var policiewView: UIView!
    
    @IBOutlet weak var contactUsLabel: UILabel!
    
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
        addGesture()
    }
    
    func adjustLayout(){
        usingIgetSpotView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 5)
        managingAccountView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 5)
        privacyView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 5)
        policiewView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 5)
        
        
        usingIgetSpotView.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 0.5, yStartPos: 0, yEndPos: 0)
        managingAccountView.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 0.5, yStartPos: 0, yEndPos: 0)
        privacyView.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 0.5, yStartPos: 0, yEndPos: 0)
        policiewView.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 0.5, yStartPos: 0, yEndPos: 0)
    }
    
    func addGesture(){
        contactUsLabel.isUserInteractionEnabled = true
        contactUsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactUsPressed(_:))))
    }
    
    @objc func onContactUsPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.onContactUsPressed()
    }
}

