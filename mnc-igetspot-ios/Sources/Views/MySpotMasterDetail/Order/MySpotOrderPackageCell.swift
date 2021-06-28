////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotOrderPackageCellDelegate:class {
    func orderPackageCellDidClicked(orderId:String, packageId:String,invoiceID:String)
    func eyeButtonDidClicked(orderId:String, packageId:String)
}

class MySpotOrderPackageCell: MKTableViewCell {
    
    @IBOutlet weak var packageContainerView: UIView!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    weak var delegate: MySpotOrderPackageCellDelegate?
    var mySpotOrderPackage: MySpotOrderPackage?
    var orderId: String?
    var invoiceId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        packageImageView.makeItRounded(width: 0, cornerRadius: 8)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            self.contentView.backgroundColor = Colors.veryLightPink
        } else {
            self.contentView.backgroundColor = .clear
        }
    }
    
    override func onSelected() {
        guard let packageId = self.mySpotOrderPackage?.packageId,  let orderId = self.orderId else {
            return
        }
        delegate?.orderPackageCellDidClicked(orderId: orderId, packageId: packageId,invoiceID: self.invoiceId ?? "")
    }
    
    func setContent(orderPackage: MySpotOrderPackage,invoiceID:String?) {
        self.mySpotOrderPackage = orderPackage
        self.invoiceId = invoiceID
        packageImageView.loadIGSImage(link: orderPackage.packageImageUrl ?? "")
        packageNameLabel.text = orderPackage.packageName
        orderDateLabel.text = orderPackage.orderDateTimeParseString
    }
    
    @IBAction func eyeButtonDidClicked() {
        guard let packageId = self.mySpotOrderPackage?.packageId,  let orderId = self.orderId else {
            return
        }
        delegate?.eyeButtonDidClicked(orderId: orderId, packageId: packageId)
    }
}
