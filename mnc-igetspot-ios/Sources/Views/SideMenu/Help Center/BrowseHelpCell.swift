//
//  BrowseHelpCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit


class BrowseHelpCell : MKTableViewCell {
    
    @IBOutlet weak var browseHelpCollection: BrowseHelpCollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        browseHelpCollection.commonInit()
    }
    
    func setContent(content : [String]){
        browseHelpCollection.setContent(list: content)
        browseHelpCollection.collectionView.collectionViewLayout.invalidateLayout()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}
