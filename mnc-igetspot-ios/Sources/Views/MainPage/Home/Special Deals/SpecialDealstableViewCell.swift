//
//  SpecialDealstableViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/18/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class SpecialDealstableViewCell : MKTableViewCell{
    
    @IBOutlet weak var specialDealsCollectionView: SpecialDealsCollectionView!
    
    @IBOutlet weak var seeAllLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
        specialDealsCollectionView.commonInit()
        specialDealsCollectionView.snp.removeConstraints()
        specialDealsCollectionView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
    }
    
    func setContent(deals: [Deals]){
        specialDealsCollectionView.setContent(deals: deals)
        specialDealsCollectionView.refreshLayout()
    }
    
    func removeContent(){
        specialDealsCollectionView.removeContent()
    }
}
