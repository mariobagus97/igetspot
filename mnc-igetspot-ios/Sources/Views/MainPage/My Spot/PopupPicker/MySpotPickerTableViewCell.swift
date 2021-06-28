//
//  MySpotPickerTableViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/30/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotPickerTableViewCellDelegate {
    func didCellSelected(id: Int, name: String)
}

class MySpotPickerTableViewCell: MKTableViewCell {
    
    @IBOutlet weak var pickerItemLabel: UILabel!
    
    var delegate : MySpotPickerTableViewCellDelegate!
    
    var name : String!
    var id : Int!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        addGesture()
        
    }
    
    func setItem(id: Int, name: String){
        self.id = id
        self.name = name
        pickerItemLabel.text = name
    }
    
    func addGesture(){
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCellSelected(_:))))
    }
    
    @objc func onCellSelected(_ sender: UITapGestureRecognizer){
        self.delegate?.didCellSelected(id: self.id, name: self.name)
    }
}
