//
//  MasterPreviewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/24/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MasterPreviewCell: MKCollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterCategoryLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 8.0)
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.3)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
    }
    
    func setupCell(master : MasterPreview) {
        masterImageView.loadIGSImage(link: master.imageUrl ?? "")
        masterNameLabel.text = master.masterName
        masterCategoryLabel.text = master.masterOf
    }
}
