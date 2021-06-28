//
//  ProfileEditButtonCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/25/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ProfileEditButtonCellDelegate {
    func onButtonPressed()
}

class ProfileEditButtonCell: MKTableViewCell {
    
    @IBOutlet weak var updateButton: UIButton!
    
    var delegate : ProfileEditButtonCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateButton.makeItRounded(width:0.0, cornerRadius : self.updateButton.bounds.height / 2)
        self.updateButton.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setTitle(title: String) {
        self.updateButton.setTitle(title, for: .normal)
    }
    
    
    @IBAction func onButtonPressed(_ sender: Any) {
        self.delegate?.onButtonPressed()
    }
    
    
}
