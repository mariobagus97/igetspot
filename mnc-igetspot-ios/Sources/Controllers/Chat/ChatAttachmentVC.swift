//
//  ChatAttachmentVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 03/07/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit
import DKImagePickerController
import DKCamera

protocol ChatAttachmentVCDelegate: class {
    func hidePanel()
    func photoSelected(image: UIImage)
    func documentSelected()
    func locationSelected()
    func showErrorMessage(message: String)
}

class ChatAttachmentVC: MKViewController {
    var delegate: ChatAttachmentVCDelegate!
    var chatAttachView: ChatAttachView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    func addViews() {
        chatAttachView = UINib(nibName: "ChatAttachView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ChatAttachView
        view.addSubview(chatAttachView)
        chatAttachView.delegate = self
        chatAttachView.enableButtonFor(document: false, location: false)
        chatAttachView.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
    }
    
    func showCamera(){
        let camera = DKCamera()
        
        camera.didCancel = {
            self.dismiss(animated: true, completion: nil)
        }
        
        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
            self.dismiss(animated: true, completion: nil)
            if let img = image {
                self.delegate?.photoSelected(image: img)
                self.delegate?.hidePanel()
            } else {
                self.delegate?.showErrorMessage(message: "Oops, error occured. Please try again.")
            }
        }
        
        self.present(camera, animated: true, completion: nil)
    }
    
    func showGalleryPicker(){
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.autoCloseOnSingleSelect = false
        pickerController.showsCancelButton = true
        pickerController.UIDelegate = CustomUIDKImagePickerDelegate()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage { (image, info) in
                    if let img = image {
                        self.delegate?.photoSelected(image: img)
                        self.delegate?.hidePanel()
                    } else {
                        self.delegate?.showErrorMessage(message: "Oops, error occured. Please try again.")
                    }
                }
            }
        }
        
        self.present(pickerController, animated: true) {}
    }
}

extension ChatAttachmentVC : ChatAttachViewDelegate {
    func getCamera() {
        showCamera()
    }
    
    func getDocument() {
        
    }
    
    func getGallery() {
        showGalleryPicker()
    }
    
    func getLocation() {
        
    }
    
    func closeAttach() {
        self.delegate?.hidePanel()
    }
    
}
