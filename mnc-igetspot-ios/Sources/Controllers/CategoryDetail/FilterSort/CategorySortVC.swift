//
//  CategorySortVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 02/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol CategorySortVCDelegate {
    func closeCategorySortVC()
    func categorySortDidSelect(selectedSort:CategoryOptionSort, categoryType:CategoryPageContentType)
}

class CategorySortVC: UIViewController {
    
    var sortView: CategorySortView!
    var delegate: CategorySortVCDelegate?
    var categoryType: CategoryPageContentType!
    var selectedOptionSort: CategoryOptionSort?
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortView = CategorySortView()
        sortView.delegate = self
        sortView.selectedSort = selectedOptionSort
        sortView.setupSortList(forCategoryType: categoryType)
        view.addSubview(sortView)
        
        sortView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(view)
        }
    }
}

// MARK:- CategorySortViewDelegate
extension CategorySortVC: CategorySortViewDelegate {
    func closeSortView() {
        delegate?.closeCategorySortVC()
    }
    
    func categorySortDidSelect(selectedSort: CategoryOptionSort) {
        delegate?.categorySortDidSelect(selectedSort: selectedSort, categoryType:categoryType)
    }
    
}
