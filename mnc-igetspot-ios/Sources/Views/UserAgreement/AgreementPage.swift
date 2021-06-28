//
//  AgreementPage.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 09/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit

class AgreementPage : UIView {
    
    @IBOutlet weak var userAgreementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUserAgreement(text : String){
        userAgreementLabel.setHTMLFromString(text: text)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
