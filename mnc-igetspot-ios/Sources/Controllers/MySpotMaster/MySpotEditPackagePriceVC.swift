//
//  MySpotEditPackagePriceVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 26/06/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotEditPackagePriceVCDelegate: class {
    func saveButtonDidClicked(price:String, editVC:MySpotEditPackagePriceVC)
}

class MySpotEditPackagePriceVC: MKViewController {

    var mySpotEditView: MySpotEditView!
    var price: String = ""
    private let saveButton = UIButton(type: .custom)
    private let cancelButton = UIButton(type: .custom)
    
    var delegate: MySpotEditPackagePriceVCDelegate?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableSwipeMenuView()
        setupNavigationBar()
        addViews()
        setContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mySpotEditView.showKeyboard(isShow: true)
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(self.title ?? "")
        setupBarButtonItem()
    }
    
    // MARK: - Actions
    @objc func saveButtonDidClicked() {
        mySpotEditView.showKeyboard(isShow: false)
        let price = mySpotEditView.textView.text.formatPriceToDigitString()
        delegate?.saveButtonDidClicked(price: price, editVC:self)
    }
    
    @objc func cancelButtonDidClicked() {
        mySpotEditView.showKeyboard(isShow: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    func setupBarButtonItem() {
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = R.font.barlowMedium(size: 14)
        cancelButton.setTitleColor(Colors.blueTwo, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClicked), for: .touchUpInside)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        saveButton.titleLabel?.font = R.font.barlowMedium(size: 14)
        saveButton.setTitleColor(Colors.blueTwo, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonDidClicked), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    func addViews() {
        mySpotEditView = MySpotEditView()
        view.addSubview(mySpotEditView)
        
        mySpotEditView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
        
        mySpotEditView.textView.placeholder = "Rp 1.000.000"
        mySpotEditView.textView.delegate = self
    }
    
    func setContent() {
        mySpotEditView.setContent(aboutString: price.currency)
    }

}

// MARK: - UITextViewDelegate
extension MySpotEditPackagePriceVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.currencyOnlyDigit
        if (text == "0") {
            saveButton.isEnabled = false
            saveButton.setTitleColor(Colors.gray, for: .normal)
        } else {
            saveButton.setTitleColor(Colors.blueTwo, for: .normal)
            saveButton.isEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == mySpotEditView.textView) {
            let textViewString: NSString = (textView.text ?? "") as NSString
            let finalString = textViewString.replacingCharacters(in: range, with: text)
            // 'currencyOnlyDigit' is a String extension that doews all the number styling
            textView.text = "Rp \(finalString.currencyOnlyDigit)"
            textViewDidChange(textView)
            // returning 'false' so that textfield will not be updated here, instead from styling extension
            return false
        }
        return true
    }
}
