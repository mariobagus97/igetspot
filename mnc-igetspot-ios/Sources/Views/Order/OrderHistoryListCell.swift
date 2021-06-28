////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderHistoryListCellDelegate:class {
    func orderHistoryListDidClicked(name:String, userId:String, masterID:String, orderID:String,packageID:String)
    func orderSuccessListDidClicked(orderSuccess: MySpotOrderSuccess)
}

class OrderHistoryListCell: MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterInfoLabel: UILabel!
    var isOrderHistory = true
    var name: String?
    var userId: String?
    var masterID: String?
    var orderID: String?
    var packageID: String?
    
    var orderSuccess: MySpotOrderSuccess?
    weak var delegate: OrderHistoryListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.containerView.backgroundColor = Colors.veryLightPink
        } else {
            self.containerView.backgroundColor = .clear
        }
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        masterImageView.setRounded()
    }
    
    func setContent(userId: String? , name:String?, description:String?, profileImageUrl:String, masterID:String?, orderID:String?,packageId:String?, isOrderHistory:Bool = true) {
        self.name = name
        self.userId = userId
        self.masterID = masterID
        self.orderID = orderID
        self.packageID = packageId
        masterNameLabel.text = name
        masterInfoLabel.text = description
        masterImageView.loadIGSImage(link: profileImageUrl, placeholderImage: R.image.userPlacaholder())
        self.isOrderHistory = isOrderHistory
    }
    
    override func onSelected() {
        if (isOrderHistory) {
            guard let userId = self.userId else {
                return
            }
            delegate?.orderHistoryListDidClicked(name: name ?? "", userId: userId,masterID: masterID ??
                "", orderID: orderID ?? "",packageID: packageID ?? "" )
        } else {
            guard let orderSuccess = self.orderSuccess else {
                return
            }
            delegate?.orderSuccessListDidClicked(orderSuccess: orderSuccess)
        }
    }
    
}
