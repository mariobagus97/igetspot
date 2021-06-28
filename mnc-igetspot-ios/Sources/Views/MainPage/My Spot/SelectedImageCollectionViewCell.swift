//
//  SelectedImageCollectionViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/2/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol SelectedImageCollectionViewCellDelegate {
    func didDeletePressed(index: Int)
}

class SelectedImageCollectionViewCell : MKCollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    var delegate : SelectedImageCollectionViewCellDelegate!
    var index : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.setRounded()
        self.containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.selectedImageView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.containerView.backgroundColor = Colors.gray
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setImage(image: UIImage){
        self.selectedImageView.image = image
    }
    
    // MARK: - Actions
    @IBAction func deleteButtonDidClicked() {
        delegate?.didDeletePressed(index: index)
    }
}
