//
//  ServicesTableViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class DynamicSizeCell : MKCollectionViewCell{
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    var cellColor:UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellColor = getRandomColor()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setupCell(subCategory : SubCategories){
        self.serviceLabel.text = subCategory.subcategoryName
        self.serviceImage.backgroundColor = cellColor
        self.serviceImage.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 5)
        self.serviceImage.contentMode = .scaleAspectFit
    }
    
    func setupCellForSearch(text: String){
        self.serviceLabel.text = text
        self.serviceImage.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 0.2, yStartPos: 0, yEndPos: 0)
        
        self.serviceImage.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 5)
        self.serviceImage.contentMode = .scaleAspectFit
    }
    
    func setupCell(withServiceCategory serviceCategory: ServiceCategory){
        self.serviceLabel.text = serviceCategory.title
        self.serviceImage.backgroundColor = cellColor
        self.serviceImage.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 5)
        self.serviceImage.contentMode = .scaleAspectFit
    }
}
