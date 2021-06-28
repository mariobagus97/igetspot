//
//  QuestionListTableCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit


class QuestionListTableCell : MKTableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(text : String){
        questionLabel.text = text
    }
}
