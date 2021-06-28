//
//  ReportProfileItemCell.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 03/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ReportProfileItemCellDelegate {
    func didItemViewPressed(title: String?)
}

class ReportProfileItemCell: MKTableViewCell {
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate : ReportProfileItemCellDelegate!
    var content: String? {
        didSet{
            titleLabel.text = content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGesture()
    }
    
    func addTapGesture() {
        itemView.isUserInteractionEnabled = true
        itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onItemViewPressed(_:))))
    }
    
    @objc func onItemViewPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.didItemViewPressed(title: content)
    }
}
