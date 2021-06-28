//
//  MasterDetailAboutDescriptionCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/16/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MasterDetailAboutDescriptionCell : MKTableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailLabel.isSkeletonable = true
        titleLabel.addCharactersSpacing(spacing: 1.0, text: NSLocalizedString("Introduction", comment: ""))
    }
    
    
    override func loadView() {
        super.loadView()
    }
    
    func setDescription(description: String){
        detailLabel.text = description
    }
    
    func showLoadingView() {
        detailLabel.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView() {
        detailLabel.hideSkeleton()
    }
    
}
