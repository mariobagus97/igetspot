//
//  BlogContentLabel.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 28/10/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class BlogContentLabel: MKTableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setContent(contentString: String){
        self.contentLabel.setHTMLFromString(text: contentString)
    }
    
}
