//
//  showImageView.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 08/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

protocol ShowImageViewDelegate {
    func didShowPressed()
    func didDeletePressed()
}

class ShowImageView: MessageView {
    
    var delegate : ShowImageViewDelegate!

    @IBOutlet weak var view: UIStackView!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var didShowPressed: (() -> Void)?
    var didDeletePressed: (() -> Void)?
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        view.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 15)
        
        showButton.setTitleColor(Colors.vividBlue, for: .normal)
//        showButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: showButton.bounds.height)
        
        deleteButton.setTitleColor(Colors.vividBlue, for: .normal)
//        deleteButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: deleteButton.bounds.height)
    }
    
    @IBAction func onShowPressed(_ sender: Any) {
        didShowPressed?()
    }
    
    @IBAction func onDeletePressed(_ sender: Any) {
        didDeletePressed?()
    }
    
}
