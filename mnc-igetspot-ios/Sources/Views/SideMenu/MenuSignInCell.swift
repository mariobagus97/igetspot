//
//  MenuSignInCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/28/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MenuSignInCellDelegate {
    func signInDidClicked()
}

class MenuSignInCell : MKTableViewCell {
    
    @IBOutlet weak var signTextLabel: UILabel!
    
    @IBOutlet weak var signInSwitch: UISwitch!
    
    var delegate : MenuSignInCellDelegate!

    
    @IBAction func onSwitchPressed(_ sender: Any) {
        signInSwitch.setOn(false, animated: true)
        delegate?.signInDidClicked()
    }
    
    override func onSelected() {
        delegate?.signInDidClicked()
    }
    
    func setSignInText(){
        signInSwitch.setOn(false, animated: true)
    }
    
    func setSignOutText(){
        signInSwitch.setOn(true, animated: true)
        
        let attributedString = NSMutableAttributedString(string: "Sign Out")
        
        attributedString.addAttributes([
            .font: UIFont(name: "Barlow-Regular", size: 12.0)!,
            .foregroundColor: UIColor.white
            ], range: NSRange(location: 0, length: 8))
        
        
        signTextLabel.attributedText = attributedString
    }
}
