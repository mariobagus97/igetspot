//
//  ServicesStackView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol SServicesStackViewDelegate: class {
    func serviceCategoryDidClicked(categoryId:String, categoryName:String, subcategoryId:String, subcategoryName: String)
}

class ServicesStackView : UIView {
    
    @IBOutlet weak var servicesStack: UIStackView!
    weak var delegate: SServicesStackViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(allServices: [AllServices]){
        if (allServices.count>0){
            
            for i in 0...allServices.count-1 {
                
                let subview = UINib(nibName: "ServicesCellView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ServicesCellView
                
                if(i==0){
                    subview.isExpanded = false
                }
                
                subview.delegate = self
                self.servicesStack.addArrangedSubview(subview)
                
                subview.allService = allServices[i]
                subview.setContent()
                
            }
        }
        
        for view in self.servicesStack.arrangedSubviews {
            view.sizeToFit()
            view.layoutIfNeeded()
        }
        
        self.servicesStack.sizeToFit()
        self.servicesStack.layoutIfNeeded()
        layoutIfNeeded()
    }
    
}

extension ServicesStackView: ServicesCellViewDelegate {
    func serviceCategoryDidClicked(categoryId: String, categoryName: String, subcategoryId: String?, subcategoryName: String?) {
        delegate?.serviceCategoryDidClicked(categoryId: categoryId, categoryName: categoryName, subcategoryId: subcategoryId ?? "", subcategoryName: subcategoryName ?? "")
    }
    
}
