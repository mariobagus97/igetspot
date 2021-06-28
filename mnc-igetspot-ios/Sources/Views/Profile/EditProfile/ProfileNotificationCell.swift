//
//  ProfileNotificationTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/26/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class ProfileNotificationCell: MKTableViewCell {
    
    @IBOutlet weak var notifLabel: UILabel!
    
    @IBOutlet weak var notifSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
       
    }
    
    func setContent(itemName: String?, isOn: Bool = false){
        notifLabel.text = itemName
        notifSwitch.setOn(isOn, animated: true)
    }
    
}
