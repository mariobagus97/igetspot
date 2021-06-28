//
//  MySpotRegistration.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/31/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KMPlaceholderTextView

protocol MySpotRegistrationWhatToOfferCellDelegate {
    func onAddPressed(position: Int)
    func onCellPressed(position: Int, index: Int)
    func onDeletePressed(position: Int)
    func showCategoryPicker(position: Int)
    func showSubCategoryPicker(position: Int)
    func showListDuration(position: Int)
    func deleteCellImage(position: Int, index: Int)
}

class MySpotRegistrationWhatToOfferCell: UIView {
    
    @IBOutlet weak var categoryField: SkyFloatingLabelTextField!
    @IBOutlet weak var subCategoryfield: SkyFloatingLabelTextField!
    @IBOutlet weak var servicePackageNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var describepackageView: KMPlaceholderTextView!
    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var selectedImageCollectionview: SelectedImageCollectionView!
    @IBOutlet weak var packagePriceField: SkyFloatingLabelTextField!
    @IBOutlet weak var packageDurationField: SkyFloatingLabelTextField!
    @IBOutlet weak var describeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedImageHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteCategoryButton: UIButton!
    @IBOutlet weak var whatDurationField: SkyFloatingLabelTextField!
    
    var position : Int!
    var categoryID = Int()
    var subcategoryID = Int()
    var cellDelegate: MySpotRegistrationWhatToOfferCellDelegate?
    let thisBaseFont = R.font.barlowRegular(size: 14)
    var imageList = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectedImageCollectionview.commonInit()
        self.selectedImageCollectionview.cellDelegate = self
        self.selectedImageCollectionview.delegate = self
        self.selectedImageCollectionview.reloadData()
        
        setupFont()
        addGesture()
    }
    
    func checkPosition(){
        if (position == 0 || position == nil){
            deleteCategoryButton.isHidden  = true
        }
    }
    
    func setSelectedPhotos(imageList: [UIImage]){
        self.imageList = imageList
        selectedImageCollectionview.setContent(imageList: imageList)
        selectedImageHeight.constant = selectedImageCollectionview.collectionView.collectionViewLayout.collectionViewContentSize.height
        layoutIfNeeded()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func getData() -> MySpotWhatToOffer {
        let data = MySpotWhatToOffer()
        
        data.categoryId = self.categoryID
        data.subcategoryId = self.subcategoryID
        data.servicePackageName = servicePackageNameField.text
        data.packageDescription = describepackageView.text
        data.packagePrice = packagePriceField.text?.formatPriceToString()
        if let duration = whatDurationField.text {
            data.packageDuration = "\(packageDurationField.text ?? "0") \(duration)"
        } else {
            data.packageDuration = packageDurationField.text ?? "0" + ""
        }
        return data
    }
    
    func setCategory(id: Int, name: String){
        self.categoryID = id
        categoryField.text = name
    }
    
    func setSubCategory(id: Int, name: String){
        self.subcategoryID = id
        subCategoryfield.text = name
    }
    
    
    func setupFont(){
        categoryField.lineHeight = 0
        categoryField.lineColor = UIColor.clear
        categoryField.placeholder = NSLocalizedString("Choose Category", comment: "")
        categoryField.title = NSLocalizedString("Choose Category", comment: "")
        categoryField.placeholderFont = self.thisBaseFont!
        categoryField.placeholderColor = Colors.placeholderGray
        categoryField.titleFont = self.thisBaseFont!
        categoryField.tintColor = Colors.blueTwo
        categoryField.selectedTitleColor = Colors.blueTwo
        categoryField.titleFormatter = { $0 }
        
        subCategoryfield.lineHeight = 0
        subCategoryfield.lineColor = UIColor.clear
        subCategoryfield.placeholder = NSLocalizedString("Detailed Category", comment: "")
        subCategoryfield.title = NSLocalizedString("Detailed Category", comment: "")
        subCategoryfield.placeholderFont = self.thisBaseFont!
        subCategoryfield.placeholderColor = Colors.placeholderGray
        subCategoryfield.titleFont = self.thisBaseFont!
        subCategoryfield.tintColor = Colors.blueTwo
        subCategoryfield.selectedTitleColor = Colors.blueTwo
        subCategoryfield.titleFormatter = { $0 }
        
        servicePackageNameField.lineHeight = 0
        servicePackageNameField.lineColor = UIColor.clear
        servicePackageNameField.placeholder = NSLocalizedString("Service Package Name", comment: "")
        servicePackageNameField.title = NSLocalizedString("Service Package Name", comment: "")
        servicePackageNameField.placeholderFont = self.thisBaseFont!
        servicePackageNameField.placeholderColor = Colors.placeholderGray
        servicePackageNameField.titleFont = self.thisBaseFont!
        servicePackageNameField.tintColor = Colors.blueTwo
        servicePackageNameField.selectedTitleColor = Colors.blueTwo
        servicePackageNameField.titleFormatter = { $0 }
        
        packagePriceField.lineHeight = 0
        packagePriceField.lineColor = UIColor.clear
        packagePriceField.placeholder = NSLocalizedString("Package Price", comment: "")
        packagePriceField.title = NSLocalizedString("Package Price", comment: "")
        packagePriceField.placeholderFont = self.thisBaseFont!
        packagePriceField.placeholderColor = Colors.placeholderGray
        packagePriceField.titleFont = self.thisBaseFont!
        packagePriceField.tintColor = Colors.blueTwo
        packagePriceField.selectedTitleColor = Colors.blueTwo
        packagePriceField.titleFormatter = { $0 }
        packagePriceField.delegate = self
        
        packageDurationField.lineHeight = 0
        packageDurationField.lineColor = UIColor.clear
        packageDurationField.placeholder = NSLocalizedString("Package Duration", comment: "")
        packageDurationField.title = NSLocalizedString("Package Duration", comment: "")
        packageDurationField.placeholderFont = self.thisBaseFont!
        packageDurationField.placeholderColor = Colors.placeholderGray
        packageDurationField.titleFont = self.thisBaseFont!
        packageDurationField.tintColor = Colors.blueTwo
        packageDurationField.selectedTitleColor = Colors.blueTwo
        packageDurationField.titleFormatter = { $0 }
        packageDurationField.delegate = self
        
        whatDurationField.lineHeight = 0
        whatDurationField.lineColor = UIColor.clear
        whatDurationField.placeholder = NSLocalizedString("Hour", comment: "")
        whatDurationField.title = NSLocalizedString("", comment: "")
        whatDurationField.placeholderFont = self.thisBaseFont!
        whatDurationField.placeholderColor = Colors.placeholderGray
        whatDurationField.titleFont = self.thisBaseFont!
        whatDurationField.tintColor = Colors.blueTwo
        whatDurationField.selectedTitleColor = Colors.blueTwo
        whatDurationField.titleFormatter = { $0 }
        whatDurationField.delegate = self
        
        describepackageView.placeholderFont = self.thisBaseFont
        describepackageView.font = self.thisBaseFont
        describepackageView.delegate = self
        
        describeLabel.textColor = .white
        
    }
    
    func addGesture(){
        
        categoryField.isUserInteractionEnabled = true
        categoryField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCategoryPicker(_:))))
        
        subCategoryfield.isUserInteractionEnabled = true
        subCategoryfield.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSubCategoryPicker(_:))))
        
        whatDurationField.isUserInteractionEnabled = true
        whatDurationField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showDuration(_:))))
    }
    
    
    @IBAction func onDeletePressed(_ sender: Any) {
        self.cellDelegate?.onDeletePressed(position: self.position)
    }
    
    
    @objc func showCategoryPicker(_ sender: UITapGestureRecognizer){
        describepackageView.resignFirstResponder()
        self.cellDelegate?.showCategoryPicker(position: self.position)
    }
    
    @objc func showSubCategoryPicker(_ sender: UITapGestureRecognizer){
        describepackageView.resignFirstResponder()
        self.cellDelegate?.showSubCategoryPicker(position: self.position)
    }
    
    @objc func showDuration(_ sender: UITapGestureRecognizer){
        describepackageView.resignFirstResponder()
        self.cellDelegate?.showListDuration(position: self.position)
    }
    
    func setDuration(name: String){
        whatDurationField.text = name
    }
}

extension MySpotRegistrationWhatToOfferCell : SelectedImageCollectionViewDelegate{
    func onDeleteImagePressed(index: Int) {
        self.cellDelegate?.deleteCellImage(position: self.position, index: index)
    }
    
    func onAddPressed() {
        self.cellDelegate?.onAddPressed(position: self.position)
    }
    
    func onCellPressed(index: Int) {
        self.cellDelegate?.onCellPressed(position: self.position, index: index)
    }
    
    func updateParentHeight(height: CGFloat){
        
    }
}

extension MySpotRegistrationWhatToOfferCell : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        describeLabel.textColor = Colors.blueTwo
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text != nil && textView.text != "") {
            describeLabel.textColor = Colors.gray
        } else {
            describeLabel.textColor = .white
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text != nil && textView.text != ""){
            describeLabel.textColor = Colors.blueTwo
            var newFrame = self.describepackageView.frame
            let width = newFrame.size.width
            let newSize = self.describepackageView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
            
            newFrame.size = CGSize(width: width, height: newSize.height)
            textView.frame = newFrame
            
            self.describeViewHeight.constant = newSize.height
            self.describepackageView.setNeedsLayout()
            self.describepackageView.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        } else {
            self.describeViewHeight.constant = 45.0
            self.describepackageView.setNeedsLayout()
            self.describepackageView.layoutIfNeeded()
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}

extension MySpotRegistrationWhatToOfferCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == packagePriceField) {
            let text: NSString = (textField.text ?? "") as NSString
            let finalString = text.replacingCharacters(in: range, with: string)
            // 'currencyOnlyDigit' is a String extension that doews all the number styling
            textField.text = "Rp.\(finalString.currencyOnlyDigit)"
            
            // returning 'false' so that textfield will not be updated here, instead from styling extension
            return false
        } else if (textField == packageDurationField) {
            //Prevent "0" characters as the first characters. (i.e.: There should not be values like "003" "01" "000012" etc.)
            if textField.text?.count == 0 && string == "0" {
                return false
            }
            
            //Have a decimal keypad. Which means user will be able to enter Double values. (Needless to say "." will be limited one)
            if (textField.text?.contains("."))! && string == "." {
                
                return false
            }
            
            //Only allow numbers. No Copy-Paste text values.
            let allowedCharacterSet = CharacterSet.init(charactersIn: "0123456789.")
            let textCharacterSet = CharacterSet.init(charactersIn: textField.text! + string)
            if !allowedCharacterSet.isSuperset(of: textCharacterSet) {
                return false
            }
        }
        
        return true
    }
}

// MARK:- MKCollectionViewDelegate
extension MySpotRegistrationWhatToOfferCell: MKCollectionViewDelegate {
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
        if let _ = selectedImageCollectionview.collectionView.cellForItem(at: indexPath) as? MySpotAddPackageCollectionCell {
            self.cellDelegate?.onAddPressed(position: self.position)
        } else if let _ = selectedImageCollectionview.collectionView.cellForItem(at: indexPath) as? SelectedImageCollectionViewCell {
            self.cellDelegate?.onCellPressed(position: self.position, index: indexPath.item)
        }
    }
}
