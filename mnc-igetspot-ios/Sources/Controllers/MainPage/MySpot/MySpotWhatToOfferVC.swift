//
//  MySpotWhatToOffer.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/31/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import DKImagePickerController
import DKCamera
import SwiftMessages

protocol MySpotWhatToOfferVCDelegate:class {
    func handleSuccess()
}

class MySpotWhatToOfferVC : MKViewController {
    
    var registrationPage : MySpotRegistrationPage!
    var imageList = [[UIImage]]()
    var position = Int()
    var mPresenter = MySpotWhatToOfferPresenter()
    var isCategoryPicker : Bool = false
    var isSubCategoryPicker : Bool = false
    var isDurationPicker : Bool = false
    var categoryList  = [String]()
    var subcategoryList: [SubCategories]?
    var allCategoryList = [AllServices]()
    var durationList = ["Hours", "Days", "Weeks", "Months" ]
    var categoryIndex = -1
    var pickerPosition = Int()
    var isFromEdit = false
    var selectedCategoryId: String?
    var indexImage : Int!
    private let cancelButton = UIButton(type: .custom)
    weak var delegate: MySpotWhatToOfferVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addView()
        mPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
        mPresenter.getCategoryList(limit: 100)
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("What You Have to Offer", comment: ""))
        if isFromEdit {
            setupCancelBarButtonItem()
        } else {
            setupLeftBackBarButtonItems(barButtonType: .backButton)
        }
        
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    func setupCancelBarButtonItem() {
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = R.font.barlowMedium(size: 14)
        cancelButton.setTitleColor(Colors.blueTwo, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClicked), for: .touchUpInside)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    @objc func cancelButtonDidClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func addView() {
        self.registrationPage = UINib(nibName: "MySpotRegistrationPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MySpotRegistrationPage
        if isFromEdit {
            registrationPage.setTItleContinueButton(title: NSLocalizedString("Save", comment: ""))
        } else {
            registrationPage.setTItleContinueButton(title: NSLocalizedString("Continue", comment: ""))
        }
        view.addSubview(registrationPage)
        imageList.append([UIImage]())
        registrationPage.delegate = self
        registrationPage.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func showPicker (){
        let pickerController = DKImagePickerController()
        pickerController.UIDelegate = CustomUIDKImagePickerDelegate()
        pickerController.showsCancelButton = true
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage { (image, info) in
                    if let img = image {
                        self.imageList[self.position].append(img)
                        self.reloadCollection()
                    }
                }
            }
        }
        
        pickerController.maxSelectableCount = 10 - self.imageList[self.position].count
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true) {}
    }
    
    func reloadCollection(){
        self.registrationPage.setSelectedPhotos(position: position, imageList: self.imageList[self.position])
    }
    
    func getAllData() -> [MySpotWhatToOffer] {
        var data = [MySpotWhatToOffer]()
        data = self.registrationPage.getData()
        
        if (imageList.count != 0){
            for row in 0...imageList.count-1 {
                var packageImages = [PackageImage]()
                
                if (imageList[row].count != 0){
                    for i in 0...imageList[row].count-1{
                        let packageImage = PackageImage()
                        
                        packageImage.file = imageList[row][i]
                        packageImage.name = data[row].servicePackageName!+String(i)
                        packageImage.types = "jpg"
                        
                        packageImages.append(packageImage)
                    }
                    
                    data[row].packageImage = packageImages
                }
            }
        }
        
        return data
    }
    
    func handleRegistrationSuccess() {
        if isFromEdit {
            self.dismiss(animated: true, completion: {
                self.delegate?.handleSuccess()
            })
        } else {
            let registrationStep3VC = MySpotRegisStep3VC()
            self.navigationController?.pushViewController(registrationStep3VC, animated: true)
        }
        
    }
    
    func setAllCategoryList(list : [AllServices]){
        self.allCategoryList = list
    }
    
}

extension MySpotWhatToOfferVC : MySpotRegistrationPageDelegate {
    func showDurationPicker(position: Int) {
        self.pickerPosition = position
        self.isCategoryPicker = false
        self.isSubCategoryPicker = false
        self.isDurationPicker = true
        let view: MySpotPickerView = try! SwiftMessages.viewFromNib()
        view.configureNoDropShadow()
        view.delegate = self
        view.setContent(stringArray: self.durationList)
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.8), interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    func onDeleteImagePressed(pos:Int, index: Int) {
        self.imageList[pos].remove(at: index)
        self.registrationPage.setSelectedPhotos(position: self.position, imageList: self.imageList[self.position])
    }
    
    func onCellImagePressed(pos: Int, index: Int) {
        IGSLightbox.showLocalImage(images: self.imageList[self.position], index: index, vc: self)
    }

    
    func showCategoryPicker(position: Int) {
        self.isCategoryPicker = true
        self.isSubCategoryPicker = false
        self.isDurationPicker = false
        self.pickerPosition = position
        let view: MySpotPickerView = try! SwiftMessages.viewFromNib()
        view.configureNoDropShadow()
        view.delegate = self
        view.setContentCategory(categoryArray: self.allCategoryList)
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.8), interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    func showSubCategoryPicker(position: Int) {
        guard let subcategoriesArray = self.subcategoryList else {
            showErrorMessageBanner(NSLocalizedString("Please pick category", comment: ""))
            return
        }
        self.isCategoryPicker = false
        self.isSubCategoryPicker = true
        self.isDurationPicker = false
        self.pickerPosition = position
        let view: MySpotPickerView = try! SwiftMessages.viewFromNib()
        view.configureNoDropShadow()
        view.delegate = self
        view.setSubCategoryList(subCategoryArray: subcategoriesArray)
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.8), interactive: true)
        SwiftMessages.show(config: config, view: view)
        
    }
    
    func onDeleteCategory(position: Int) {
        self.position -= 1
        self.imageList.remove(at: position)
    }
    
    func onContinuePressed() {
        if isFromEdit {
            self.mPresenter.savePackageMySpot(data: self.getAllData())
        } else {
            self.mPresenter.uploadRegistration(registrationData: self.getAllData())
        }
    }
    
    func onAddPressed(position: Int){
        self.position = position
        showPicker()
    }
    
    func showAlert(){
        // create the alert
        let alert = UIAlertController(title: "Choose Category", message: "Please select category", preferredStyle: .alert)
        
        // add an action (button)
        //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: hideAlert))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //    func hideAlert(action: UIAlertAction) {
    //        dismiss(animated: true, completion: nil)
    //    }
    
    func onAddMorePressed() {
        self.imageList.append([UIImage]())
    }
}


extension MySpotWhatToOfferVC : CustomPopupTVCDelegate {
    func selectedCell(id: Int, name: String) {
        dismiss(animated: true, completion: nil)
        if (id == 0){
            IGSLightbox.showLocalImage(images: self.imageList[position], index: self.indexImage, vc: self)
        } else {
            self.imageList[self.position].remove(at: self.indexImage)
            self.registrationPage.setSelectedPhotos(position: self.position, imageList: self.imageList[self.position])
        }
    }
}

extension MySpotWhatToOfferVC: MySpotPickerViewDelegate {
    func mySpotPickerCloseButtonDidClicked() {
        SwiftMessages.hide()
    }
    
    func mySpotPickerDidSelectedCell(id: Int, name: String) {
        SwiftMessages.hide()
        if (isCategoryPicker) {
            self.categoryIndex = pickerPosition
            self.registrationPage.setCategoryField(position: pickerPosition, id: id, name: name)
            if let indexOfCategories = allCategoryList.index(where: {$0.categoryId == id}) {
                let category = allCategoryList[indexOfCategories]
                if let subcategories = category.subcategories, subcategories.count > 0 {
                    self.subcategoryList = subcategories
                    let subcategory = subcategories[0]
                    if let id = subcategory.subcategoryId, let name = subcategory.subcategoryName {
                        self.registrationPage.setSubCategoryField(position: pickerPosition, id: id, name: name)
                    }
                }
            }
        } else if (isDurationPicker){
            self.registrationPage.setDuration(position: pickerPosition, name: name)
        } else {
            self.registrationPage.setSubCategoryField(position: pickerPosition, id: id, name: name)
        }
    }
}
