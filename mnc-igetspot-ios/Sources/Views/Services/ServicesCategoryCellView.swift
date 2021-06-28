//
//  ServicesCategoryCellView.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 22/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class ServicesCategoryCellView : UICollectionViewCell {
    
    @IBOutlet weak var servicesCellLabel: UILabel!
    var text = ""
    var updateHeight = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 5)
    }
    
    func setLabel(text: String){
        self.text = text
        self.servicesCellLabel.text = text
        layoutIfNeeded()
    }
    
    func setGradient(){
        self.servicesCellLabel.textColor = .white
        self.applyGradient(colors: [UIColor.rgb(red: 4, green: 51, blue: 255), UIColor.rgb(red: 253, green: 47, blue: 149)], xStartPos: 0, xEndPos: 0.2, yStartPos: 0, yEndPos: 0)
        
    }
    
    func setColor(color : UIColor){
        self.backgroundColor = self.getRandomColor()
        layoutIfNeeded()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        setNeedsLayout()
        layoutIfNeeded()
        
        if (self.text != ""){
            let size = CellSizeProvider.provideTagCellSize(item: self.text)
            frame.size.width = size.width
            if (!updateHeight) {
                frame.size.height = size.height
            } else {
                frame.size.height = 50
            }
            layoutAttributes.frame = frame
        }

        return layoutAttributes
    }
    
}
