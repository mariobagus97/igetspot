//
//  MorePage.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 02/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MorePageDelegate {
    func didReportProfileViewPressed()
    func didBlockProfileViewPressed()
}

class MorePage: UIView {
    
    @IBOutlet weak var reportProfileView: UIView!
    @IBOutlet weak var blockProfileView: UIView!
    
    var delegate : MorePageDelegate!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        addTapGesture()
    }
    
    func addTapGesture(){
        reportProfileView.isUserInteractionEnabled = true
        reportProfileView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                      action: #selector(onReportProfileViewPressed(_:))))
        
        blockProfileView.isUserInteractionEnabled = true
        blockProfileView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(onBlockProfileViewPressed(_:))))
    }
    
    @objc func onReportProfileViewPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.didReportProfileViewPressed()
    }

    @objc func onBlockProfileViewPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.didBlockProfileViewPressed()
    }
}
