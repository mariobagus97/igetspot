////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class HistoryOrderPackageCell: MKTableViewCell {
    
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var dateOrderLabel: UILabel!
    var orderPackage: OrderHistoryPackage?

    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        packageImageView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: 8)
    }
    
    // MARK: - Public Functions
    func setContent(orderPackage:OrderHistoryPackage) {
        self.orderPackage = orderPackage
        packageImageView.loadIGSImage(link: orderPackage.packageImageUrl ?? "")
        packageNameLabel.text = orderPackage.packageName
        dateOrderLabel.text = orderPackage.orderDateString
    }
}
