////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol TransactionActivePackageCellDelegate:class {
    func transactionActiveEyeButtonDidClicked(transactionPackage:ActiveTransactionPackage, orderId:String)
    func transactionActivePackageCellDidSelect(transactionPackage:ActiveTransactionPackage, transactionId:String, orderId: String)
}

class TransactionActivePackageCell: MKTableViewCell {
    
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var eyeButton: UIButton!
    var transactionPackage: ActiveTransactionPackage?
    var orderId: String?
    var transactionId: String?
    weak var delegate: TransactionActivePackageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.contentView.backgroundColor = Colors.veryLightPink
        } else {
            self.contentView.backgroundColor = .clear
        }
    }
    
    override func onSelected() {
        guard let transactionPackage = self.transactionPackage, let transactionId = self.transactionId, let orderId = self.orderId else {
            return
        }
        delegate?.transactionActivePackageCellDidSelect(transactionPackage: transactionPackage, transactionId: transactionId, orderId: orderId)
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        packageImageView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: 8)
    }
    
    // MARK: - Public Functions
    func setContent(transactionPackage:ActiveTransactionPackage, orderId:String, transactionId:String) {
        self.transactionPackage = transactionPackage
        self.orderId = orderId
        self.transactionId = transactionId
        packageImageView.loadIGSImage(link: transactionPackage.packageImageUrl ?? "")
        packageNameLabel.text = transactionPackage.packageName
        packagePriceLabel.text = transactionPackage.packagePrice?.currency
    }
    
    // MARK: - Actions
    @IBAction func eyeButtonDidClicked() {
        guard let transactionPackage = self.transactionPackage, let orderId = self.orderId else {
            return
        }
        delegate?.transactionActiveEyeButtonDidClicked(transactionPackage: transactionPackage, orderId: orderId)
    }
}
