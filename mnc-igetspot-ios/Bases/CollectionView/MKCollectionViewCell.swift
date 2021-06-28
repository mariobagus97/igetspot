//
//  MKCollectionViewCell.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

class MKCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadView() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    func onSelected() {}
    
    
}
