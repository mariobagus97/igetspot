//
//  MySpotPickerView.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 08/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

enum MySpotRegistrationDataType {
    case stringArray
    case categoryArray
    case subCategoryArray
}

protocol MySpotPickerViewDelegate:class {
    func mySpotPickerCloseButtonDidClicked()
    func mySpotPickerDidSelectedCell(id: Int, name: String)
}

class MySpotPickerView: MessageView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewTitleLabel: UILabel!
    weak var delegate: MySpotPickerViewDelegate?
    
    var stringArray: [String]?
    var categoryArray: [AllServices]?
    var subCategoryArray: [SubCategories]?
    var pickerType: MySpotRegistrationDataType = .stringArray
    var selectedTitle: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        tableView.register(UINib(nibName: "IGSSelectCell", bundle: nil), forCellReuseIdentifier: "IGSSelectCell")
    }
    
    private func updateHeightTableView() {
        self.tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = self.tableView.contentSize.height
    }
    
    // MARK: - Public Functions
    func setTitle(title:String) {
        self.pickerViewTitleLabel.text = title
    }
    
    func setContent(stringArray:[String]) {
        self.pickerType = .stringArray
        self.stringArray = stringArray
        updateHeightTableView()
    }
    
    func setContentCategory(categoryArray : [AllServices]){
        self.pickerType = .categoryArray
        self.categoryArray = categoryArray
        setTitle(title: NSLocalizedString("Pick Category", comment: ""))
        updateHeightTableView()
    }
    
    func setSubCategoryList(subCategoryArray : [SubCategories]){
        self.pickerType = .subCategoryArray
        self.subCategoryArray = subCategoryArray
        setTitle(title: NSLocalizedString("Pick Sub Category", comment: ""))
        updateHeightTableView()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonDidClicked() {
        delegate?.mySpotPickerCloseButtonDidClicked()
    }
}

// MARK: - UITableViewDelegate
extension MySpotPickerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var name = ""
        var id = 0
        if pickerType == .stringArray, let stringArray = self.stringArray{
            name = stringArray[indexPath.row]
        } else if pickerType == .categoryArray, let categoryArray = self.categoryArray {
            let category = categoryArray[indexPath.row]
            name = category.categoryMenu ?? ""
            id = category.categoryId ?? 0
        } else if pickerType == .subCategoryArray, let subCategoryArray = self.subCategoryArray {
            let subCategory = subCategoryArray[indexPath.row]
            name = subCategory.subcategoryName ?? ""
            id = subCategory.subcategoryId ?? 0
        }
        selectedTitle = name
        delegate?.mySpotPickerDidSelectedCell(id: id, name:name)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDataSource
extension MySpotPickerView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalRow = 0
        if pickerType == .stringArray {
            guard let stringArray = self.stringArray else {
                return 0
            }
            totalRow = stringArray.count
        } else if pickerType == .categoryArray {
            guard let categoryArray = self.categoryArray else {
                return 0
            }
            totalRow = categoryArray.count
        } else if pickerType == .subCategoryArray {
            guard let subCategoryArray = self.subCategoryArray else {
                return 0
            }
            totalRow = subCategoryArray.count
        }
        return totalRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pickerType == .stringArray, let stringArray = self.stringArray {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IGSSelectCell", for: indexPath) as! IGSSelectCell
            let name = stringArray[indexPath.row]
            cell.titleLabel.text = name
            if name == selectedTitle {
                cell.selectedImageView.alpha = 1.0
            } else {
                cell.selectedImageView.alpha = 0.0
            }
            return cell
        } else if pickerType == .categoryArray, let categoryArray = self.categoryArray {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IGSSelectCell", for: indexPath) as! IGSSelectCell
            let category = categoryArray[indexPath.row]
            let name = category.categoryMenu
            cell.titleLabel.text = name
            if name == selectedTitle {
                cell.selectedImageView.alpha = 1.0
            } else {
                cell.selectedImageView.alpha = 0.0
            }
            return cell
            
        } else if pickerType == .subCategoryArray, let subCategoryArray = self.subCategoryArray {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IGSSelectCell", for: indexPath) as! IGSSelectCell
            let subCategory = subCategoryArray[indexPath.row]
            let name = subCategory.subcategoryName
            cell.titleLabel.text = name
            if name == selectedTitle {
                cell.selectedImageView.alpha = 1.0
            } else {
                cell.selectedImageView.alpha = 0.0
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
    }
}
