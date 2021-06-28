//
//  MasterOfTheWeekCollectionViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/5/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import SnapKit
import UIKit
import Alamofire

protocol MasterOfTheWeekCollectionViewCellDelegate {
    func onItemPressed(item: MasterPreview)
}

class MasterOfTheWeekCollectionViewCell: MKCollectionViewCell{
    
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterServiceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    
    var delegate:  MasterOfTheWeekCollectionViewCellDelegate?
    var master: MasterPreview?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(isPressed(_:))))
        containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.4)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setupCell(){
        
        if let item = master {
            self.masterNameLabel.text = item.masterName
            self.masterImageView.loadIGSImage(link: master?.imageUrl ?? "")
            self.masterServiceLabel.text = item.masterOf
        }
    }
    
    @objc func isPressed(_ sender: UITapGestureRecognizer){
        guard let masterPreview = self.master else {
            return
        }
        self.delegate?.onItemPressed(item: masterPreview)
    }
}
