//
//  ItemAddMoreCategoryCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/31/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ItemAddMoreCategoryCellDelegate {
    func onAddPressed()
}

class ItemAddMoreCategoryCell : MKTableViewCell{
    
    var delegate : ItemAddMoreCategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    @IBAction func onAddPressed(_ sender: Any) {
        self.delegate?.onAddPressed()
    }
}
