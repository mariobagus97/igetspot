//
//  HelpContactus.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol HelpContactUsDelegate {
    func onContactUsPressed()
}

class HelpContactUs : UIView {
    var delegate : HelpContactUsDelegate!
    
    @IBOutlet weak var contactUsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGesture()
    }
    
    func addGesture(){
        contactUsLabel.isUserInteractionEnabled = true
        contactUsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContactUsPressed(_:))))
    }
    
    @objc func onContactUsPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.onContactUsPressed()
    }
}
