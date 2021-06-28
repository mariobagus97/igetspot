//
//  ChatAttachView.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 03/07/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ChatAttachViewDelegate: class {
    func getCamera()
    func getDocument()
    func getGallery()
    func getLocation()
    func closeAttach()
}

class ChatAttachView: UIView {
    
    @IBOutlet weak var cameraContainer: UIView!
    @IBOutlet weak var documentContainer: UIView!
    @IBOutlet weak var galleryContainer: UIView!
    @IBOutlet weak var locationContainer: UIView!
    weak var delegate: ChatAttachViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAction()
    }
    
    func enableButtonFor(camera: Bool = true, document: Bool = true, gallery: Bool = true, location: Bool = true) {
        self.cameraContainer.isHidden = !camera
        self.documentContainer.isHidden = !document
        self.galleryContainer.isHidden = !gallery
        self.locationContainer.isHidden = !location
    }
    
    func setAction(){
        cameraContainer.isUserInteractionEnabled = true
        cameraContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCameraPressed(_:))))
        
        documentContainer.isUserInteractionEnabled = true
        documentContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDocumentPressed(_:))))
        
        galleryContainer.isUserInteractionEnabled = true
        galleryContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGalleryPressed(_:))))
        
        locationContainer.isUserInteractionEnabled = true
        locationContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLocationPressed(_:))))
    }
    
    @objc func onCameraPressed(_ sender: UITapGestureRecognizer){
        delegate?.getCamera()
    }
    
    @objc func onDocumentPressed(_ sender: UITapGestureRecognizer){
        delegate?.getDocument()
    }
    
    @objc func onGalleryPressed(_ sender: UITapGestureRecognizer){
        delegate?.getGallery()
    }
    
    @objc func onLocationPressed(_ sender: UITapGestureRecognizer){
        delegate?.getLocation()
    }
    
    @IBAction func onClosePressed(_ sender: Any) {
        delegate?.closeAttach()
    }
}
