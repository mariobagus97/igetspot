//
//  CategoryFilterVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 02/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol CategoryFilterVCDelegate {
    func closeCategoryFilterVC()
    func categoryFilterDidApplied(categoryType:CategoryPageContentType, parameters:[String:String]?)
}

class CategoryFilterVC: MKViewController {
    var filterView: CategoryFilterView!
    var delegate: CategoryFilterVCDelegate?
    var categoryType: CategoryPageContentType!
    var parameters:[String:String]?
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterView = CategoryFilterView()
        filterView.delegate = self
        view.addSubview(filterView)
        
        filterView.setupLayout(categoryPageType: categoryType, currentParameters: parameters)
        filterView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }
}

// MARK:- CategoryFilterViewDelegate
extension CategoryFilterVC: CategoryFilterViewDelegate {
    
    func closeFilterView() {
        delegate?.closeCategoryFilterVC()
    }
    
    func categoryFilterDidApplied(parameters: [String : String]?) {
        delegate?.categoryFilterDidApplied(categoryType: categoryType, parameters: parameters)
    }
}
