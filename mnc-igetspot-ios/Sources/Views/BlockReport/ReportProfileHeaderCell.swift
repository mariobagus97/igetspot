//
//  ReportProfileHeaderCell.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 03/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit

class ReportProfileHeaderCell: MKTableViewCell {
    let titleString = "Please select a problem to continue"
    let subtitleString = "You can report this after selecting a problem"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = titleString
        subtitleLabel.text = subtitleString
    }
    
}
