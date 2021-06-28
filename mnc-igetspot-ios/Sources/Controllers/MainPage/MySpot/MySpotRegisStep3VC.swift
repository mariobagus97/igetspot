//
//  MySpotRegisStep3.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/1/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import DKImagePickerController
import DKCamera
import FloatingPanel

class MySpotRegisStep3VC : MKViewController {
    
    let registrationPage = UINib(nibName: "MySpotRegistrationStep3", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MySpotRegistrationStep3
    var type: Int!
    let ADD_ID_NUMBER_IMAGE = 1
    let ADD_SELFIE_IMAGE = 2
    var photoIdImage : UIImage?
    var selfieIdImage : UIImage?
    var mPresenter = MySpotRegisStep3Presenter()
    var thisdata : MySpotRegisStep3!
    var thanksPageFPC: FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        addView()
        self.mPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("We Need to Know If Youre a Human", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    func showThanksPageFPC() {
        thanksPageFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        thanksPageFPC?.surfaceView.cornerRadius = 8.0
        thanksPageFPC?.surfaceView.shadowHidden = false
        thanksPageFPC?.isRemovalInteractionEnabled = true
        thanksPageFPC?.panGestureRecognizer.isEnabled = false
        thanksPageFPC?.delegate = self
        
        let contentVC = MySpotSuccessRegistrationVC()
        contentVC.delegate = self
        
        // Set a content view controller
        thanksPageFPC?.set(contentViewController: contentVC)
        
        //  Add FloatingPanel to self.view
        self.present(thanksPageFPC!, animated: true, completion: nil)
        
    }
    
    func addView (){
        registrationPage.delegate = self
        
        self.view.addSubview(registrationPage)
        
        registrationPage.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func showPicker (){
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.autoCloseOnSingleSelect = false
        pickerController.showsCancelButton = true
        pickerController.UIDelegate = CustomUIDKImagePickerDelegate()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
            for asset in assets {
                asset.fetchOriginalImage { (image, info) in
                    if let img = image {
                        
                        self.reloadCollection(image:img)
                    }
                }
            }
        }
        
        self.present(pickerController, animated: true) {}
    }
    
    func reloadCollection(image: UIImage){
        if (self.type == ADD_ID_NUMBER_IMAGE){
            self.photoIdImage = image
            self.registrationPage.setPhotoID(image: image)
        } else {
            self.selfieIdImage = image
            self.registrationPage.setPhotoSelfe(image: image)
        }
    }
    
    func successRegistration() {
        UserProfileManager.shared.updateUserLevelToMaster()
        showThanksPageFPC()
    }
}

// MARK:- MySpotRegistrationStep3Delegate
extension MySpotRegisStep3VC : MySpotRegistrationStep3Delegate{
    func showToast(message: String) {
        showErrorMessageBanner(message)
    }
    
    func onGetMySpotPressed(data: MySpotRegisStep3) {
        data.photoId = self.photoIdImage
        data.selfieId = self.selfieIdImage
        self.thisdata = data
        self.mPresenter.uploadRegistration(registrationData: self.thisdata)
    }
    
    func onAddPhotosClicked() {
        self.type = ADD_ID_NUMBER_IMAGE
        showPicker()
    }
    
    func onAddSelfiePhotoClicked() {
        self.type = ADD_SELFIE_IMAGE
        showPicker()
    }
}

// MARK:- MySpotSuccessRegistrationVCDelegate
extension MySpotRegisStep3VC: MySpotSuccessRegistrationVCDelegate {
    func redirectToManageMySpotPage() {
        if let thanksPageFPC = self.thanksPageFPC {
            thanksPageFPC.dismiss(animated: true, completion: nil)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func redirectToManageOfficialSpotPage() {
        
    }
}

// MARK:- FloatingPanelControllerDelegate
extension MySpotRegisStep3VC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ThanksPagePanelLayout()
    }
}

class ThanksPagePanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 10.0 // A top inset from safe area
        default: return nil // Or `case .hidden: return nil`
        }
    }
}
