//
//  ItemTextFieldCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/31/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class ItemTextFieldCell: MKTableViewCell {
    
    @IBOutlet weak var containerItemTextField: UIView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    
    @IBOutlet weak var itemContentField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setContent(itemName: String, itemContent: String){
        itemNameLabel.text = itemName
        
        itemNameLabel.contentMode = .scaleToFill
        itemNameLabel.numberOfLines = 2
        
        itemContentField.text = itemContent
    }
    
}
