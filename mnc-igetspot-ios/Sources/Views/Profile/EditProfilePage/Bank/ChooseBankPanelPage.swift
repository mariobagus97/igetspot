//
//  ChooseBankPanelPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/26/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import DLRadioButton

protocol ChooseBankPanelPageDelegate {
    func setBank(name: String)
    func hideSelf()
}

class ChooseBankPanelPage: UIView {
    
    @IBOutlet weak var bcaButton: DLRadioButton!
    
    @IBOutlet weak var bniButton: DLRadioButton!
    
    @IBOutlet weak var briButton: DLRadioButton!
    
    @IBOutlet weak var mandiriButton: DLRadioButton!
    
    @IBOutlet weak var bcaContainerView: UIView!
    
    @IBOutlet weak var bniContainerView: UIView!
    
    @IBOutlet weak var briContainerView: UIView!
    
    @IBOutlet weak var mandiriContainerView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    var delegate : ChooseBankPanelPageDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
        addGesture()
    }
    
    func adjustLayout(){
          containerView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 10)
    }
    
    func addGesture(){
        bcaContainerView.isUserInteractionEnabled = true
        bcaContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBcaPressed(_:))))
        
        bniContainerView.isUserInteractionEnabled = true
        bniContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBniPressed(_:))))
        
        briContainerView.isUserInteractionEnabled = true
        briContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onBriPressed(_:))))
        
        mandiriContainerView.isUserInteractionEnabled = true
        mandiriContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMandiriPressed(_:))))
    }
    
    
    @objc func onBcaPressed(_ sender: UITapGestureRecognizer){
        bcaButton.selected()
        self.delegate?.setBank(name: "BCA")
    }
    
    @objc func onBniPressed(_ sender: UITapGestureRecognizer){
        bniButton.selected()
        self.delegate?.setBank(name: "BNI")
    }
    
    @objc func onBriPressed(_ sender: UITapGestureRecognizer){
        briButton.selected()
        self.delegate?.setBank(name: "BRI")
    }
    
    @objc func onMandiriPressed(_ sender: UITapGestureRecognizer){
        mandiriButton.selected()
        self.delegate?.setBank(name: "Mandiri")
    }
    
    func setButton(name : String){
        switch name {
        case "BCA":
            print("here")
        case "BNI":
            print("here")
        case "BRI":
            print("here")
        case "Mandiri":
            print("here")
        default:
            print("default")
        }
    }
    
    @IBAction func onClosePressed(_ sender: Any) {
        self.delegate?.hideSelf()
    }
}
