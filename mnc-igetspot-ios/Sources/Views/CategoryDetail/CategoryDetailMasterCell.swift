//
//  CategoryDetailMasterCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol CategoryDetailMasterCellDelegate: class {
    func masterCellDidSelect(masterList:MasterList)
}

class CategoryDetailMasterCell : MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterRatingLabel: UILabel!
    weak var delegate: CategoryDetailMasterCellDelegate?
    var masterList:MasterList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        masterImageView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: 8)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.containerView.backgroundColor = Colors.veryLightPink
        } else {
            self.containerView.backgroundColor = .clear
        }
    }
    
    func setContent(masterList: MasterList) {
        self.masterList = masterList
        
        masterImageView.loadIGSImage(link: masterList.imageUrl ?? "")
        masterNameLabel.text = masterList.name
        masterRatingLabel.text = "\(masterList.rating ?? 0)"
    }
    
    override func onSelected() {
        guard let master = self.masterList else {
            return
        }
        delegate?.masterCellDidSelect(masterList: master)
    }
    
}
