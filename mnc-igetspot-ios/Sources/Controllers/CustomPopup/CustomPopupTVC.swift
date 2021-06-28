//
//  CustomPopupTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/30/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

protocol CustomPopupTVCDelegate {
    func selectedCell(id: Int, name: String)
}

class CustomPopupTVC: MKTableViewController {
    
    var section = MKTableViewSection()
    var cell : MySpotPickerTableViewCell!
    
    var delegate : CustomPopupTVCDelegate!
    
    var itemList = [String]()
    
    var categoryList = [AllServices]()
    
    var subCategoryList = [SubCategories]()
    
    let category = 1
    let subcategory = 2
    let nameOfString = 3
    
    var itemType : Int!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.mySpotPickerTableViewCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(section)
    }
    
    override func createRows() {
        super.createRows()
        
        addRows()
    
    }
    
    func setItemList(list: [String]){
        self.itemType = nameOfString
        self.itemList = list
    }
    
    func setCategoryList(list : [AllServices]){
        self.itemType = category
        self.categoryList.append(contentsOf: list)
        for item in list {
            self.itemList.append(item.categoryMenu ?? "")
        }
    }
    
    func setSubCategoryList(list : [SubCategories]){
        self.itemType = subcategory
        self.subCategoryList.append(contentsOf: list)
        for item in list {
            self.itemList.append(item.subcategoryName ?? "")
        }
    }
    
    func addRows(){
        if (itemList.count > 0){
            for row in 0...itemList.count-1 {
                cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotPickerTableViewCell.name) as? MySpotPickerTableViewCell
                
                cell.delegate = self
                
                cell.setItem(id:row, name: self.itemList[row])
                
                section.appendRow(cell: cell)
                
            }
        }
    }
}

extension CustomPopupTVC : MySpotPickerTableViewCellDelegate {
    func didCellSelected(id: Int, name: String) {
        
        switch self.itemType {
        case self.category:
            self.delegate?.selectedCell(id: self.categoryList[id].categoryId!, name: name)
        case self.subcategory:
            self.delegate?.selectedCell(id: self.subCategoryList[id].subcategoryId!, name: name)
        case self.nameOfString:
            self.delegate?.selectedCell(id: id, name: name)
        default : print("error")
        }
    }
}
