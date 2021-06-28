////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol PackageOrderCellDelegate:class {
    func deleteButtonDidClicked(orderPackage:OrderPackage, orderId:String?)
    func deleteButtonDidClicked(orderPackage:OrderPackage, masterId:String?)
    func checkListButtonDidClicked(orderPackage:OrderPackage)
}

class PackageOrderCell: MKTableViewCell {
    
    @IBOutlet weak var checklistButton: UIButton!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var widthChecklistButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthDeleteButtonConstraint: NSLayoutConstraint!
    var isClickable = false
    var orderPackage: OrderPackage?
    var orderId:String?
    var masterId:String?
    weak var delegate: PackageOrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted && isClickable {
            self.contentView.backgroundColor = Colors.veryLightPink
        } else {
            self.contentView.backgroundColor = .clear
        }
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        packageImageView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: 8)
    }

    // MARK: - Actions
    @IBAction func checklistButtonDidClicked() {
        guard let orderPackage = self.orderPackage else {
            return
        }
        delegate?.checkListButtonDidClicked(orderPackage: orderPackage)
    }
    
    @IBAction func deleteButtonDidClicked() {
        guard let orderPackage = self.orderPackage else {
            return
        }
        if let masterId = self.masterId, masterId.isEmptyOrWhitespace() == false {
            delegate?.deleteButtonDidClicked(orderPackage: orderPackage, masterId:masterId)
        } else if let orderId = self.orderId, orderId.isEmptyOrWhitespace() == false {
            delegate?.deleteButtonDidClicked(orderPackage: orderPackage, orderId: orderId)
        }
    }
    
    // MARK: - Public Functions
    func setContent(orderPackage:OrderPackage) {
        self.orderPackage = orderPackage
        let selectedImage = R.image.selectedOrder()
        let unselectedImage = R.image.unselectedOrder()
        if (orderPackage.isSelected) {
            checklistButton.setImage(selectedImage, for: .normal)
        } else {
            checklistButton.setImage(unselectedImage, for: .normal)
        }
        packageImageView.loadIGSImage(link: orderPackage.packageImageUrl ?? "")
        packageNameLabel.text = orderPackage.packageName
        packagePriceLabel.text = orderPackage.packagePrice?.currency
    }
    
    func hideDeleteButton() {
        self.widthDeleteButtonConstraint.constant = 0
        self.layoutIfNeeded()
    }
    
    func showDeleteButton() {
        self.widthDeleteButtonConstraint.constant = 30
        self.layoutIfNeeded()
    }
    
    func hideChecklistButton() {
        self.widthChecklistButtonConstraint.constant = 0
        self.layoutIfNeeded()
    }
}
