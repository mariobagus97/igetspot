////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import DKImagePickerController
import DKCamera
import SwiftMessages
import FloatingPanel

protocol MySpotFinishYourOrderVCDelegate:class {
    func backToMyOrderSuccess()
}

class MySpotFinishYourOrderVC: MKViewController {
    
    var presenter = MySpotFinishYourOrderPresenter()
    var finishOrderView: MySpotFinishYourOrderView!
    var orderId:String?
    var invoiceID:String?
    var packageID:String?
    var finishConfirmationFPC: FloatingPanelController?
    weak var delegate:MySpotFinishYourOrderVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addViews()
        presenter.attachview(self)
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Finish Your Order", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    // MARK: - Private Functions
    private func addViews() {
        finishOrderView = MySpotFinishYourOrderView()
        finishOrderView.delegate = self
        view.addSubview(finishOrderView)
        finishOrderView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    private func showPicker() {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.autoCloseOnSingleSelect = false
        pickerController.showsCancelButton = true
        pickerController.UIDelegate = CustomUIDKImagePickerDelegate()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage { (image, info) in
                    if let img = image {
                        self.finishOrderView.setPhotoImage(image: img)
                    }
                }
            }
        }
        present(pickerController, animated: true) {}
    }
    
    private func showFinishConfirmationFPC() {
        finishConfirmationFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        finishConfirmationFPC?.surfaceView.cornerRadius = 8.0
        finishConfirmationFPC?.surfaceView.shadowHidden = false
        finishConfirmationFPC?.isRemovalInteractionEnabled = false
        finishConfirmationFPC?.delegate = self
        
        let contentVC = MySpotFinishConfirmationVC()
        contentVC.delegate = self
        
        // Set a content view controller
        finishConfirmationFPC?.set(contentViewController: contentVC)
        present(finishConfirmationFPC!, animated: true, completion: nil)
    }
    
    private func hideFinishConfirmationFPC(animated:Bool) {
        if let finishConfirmationFPC = self.finishConfirmationFPC {
            finishConfirmationFPC.dismiss(animated: animated, completion: nil)
        }
    }

}

// MARK: - MySpotFinishYourOrderDelegate
extension MySpotFinishYourOrderVC: MySpotFinishYourOrderDelegate{
    func showOrderLoadingHUD() {
        showLoadingHUD()
    }
    func hideOrderLoadingHUD() {
        hideLoadingHUD()
    }
    func handleFinishOrderSuccess() {
        showFinishConfirmationFPC()
    }
    func showMessageError(message:String) {
        showErrorMessageBanner(message)
    }
}

// MARK: - MySpotFinishYourOrderViewDelegate
extension MySpotFinishYourOrderVC: MySpotFinishYourOrderViewDelegate {
    func finishOrderButtonDidClicked() {
        guard let image = finishOrderView.imageView.image, let orderId = self.orderId else {
            self.showErrorMessageBanner("Please add photo to proof this order has finished")
            return
        }
        showAlertMessage(title: "Finish This Order", message: "Are you sure to finish this order?", iconImage: nil, okButtonTitle: NSLocalizedString("Finish", comment: ""), okAction: {
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presenter.requestFinishOrder(orderId: orderId,invoiceID: self.invoiceID ?? "", packageID: self.packageID ?? "", image: image)
            }
        }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
            SwiftMessages.hide()
        })
    }
    
    func photoButtonDidClicked() {
        showPicker()
    }
}

// MARK:- FloatingPanelControllerDelegate
extension MySpotFinishYourOrderVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == finishConfirmationFPC {
            return FullPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        hideFinishConfirmationFPC(animated: false)
        delegate?.backToMyOrderSuccess()
        navigationController?.popViewController(animated: false)
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if vc == finishConfirmationFPC {
            finishConfirmationFPC = nil
        }
    }
}

// MARK:- MySpotFinishConfirmationVCDelegate
extension MySpotFinishYourOrderVC: MySpotFinishConfirmationVCDelegate {
    func backToOrderButtonDidClicked() {
        hideFinishConfirmationFPC(animated: false)
        delegate?.backToMyOrderSuccess()
        navigationController?.popViewController(animated: false)
    }
}
