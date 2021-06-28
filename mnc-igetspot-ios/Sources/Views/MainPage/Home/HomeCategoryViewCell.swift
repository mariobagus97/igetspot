//
//  HomeCategoryViewCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class HomeCategoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleCategoryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        isSkeletonable = true
        containerView.isSkeletonable = true
        iconImageView.isSkeletonable = true
        titleCategoryLabel.isSkeletonable = true
        
        iconImageView.setRounded()
        contentView.makeItRounded(width: 0, borderColor: Colors.gray.cgColor, cornerRadius: 6)
    }
    
    func setContent(homeCategories:HomeCategory) {
        if (homeCategories.categoryName == "More"){
            iconImageView.image = R.image.icMenuMore()
        } else {
            iconImageView.loadIGSImage(link: homeCategories.imageUrl ?? "")
        }
        
        DispatchQueue.main.async {
            self.titleCategoryLabel.text = homeCategories.categoryName
        }
    }

}
