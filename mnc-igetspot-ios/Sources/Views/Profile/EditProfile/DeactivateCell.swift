//
//  DeactivateCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/20/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class DeactivateCell : MKTableViewCell {
    @IBOutlet weak var deactivateSwitch: UISwitch!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    func getSwitchValue() -> Bool {
        return deactivateSwitch.isOn
    }
    
    
}
