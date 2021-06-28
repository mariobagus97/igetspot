////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class TransactionStatusCell: MKTableViewCell {
    
    @IBOutlet weak var checklistImageView: UIImageView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var titleStatusLabel: UILabel!
    @IBOutlet weak var descriptionStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        checklistImageView.setRounded()
    }
    
    func setContent(transactionStatus:TransactionStatus, nextTransactionStatus:Bool) {
        let replacedTitle = transactionStatus.statusTitle?.replacingOccurrences(of: "Ww", with: "W")
        titleStatusLabel.text = replacedTitle
        descriptionStatusLabel.text = transactionStatus.statusDescription
        if transactionStatus.statusDone == false {
            setUndone()
        } else {
            setDone()
        }
        
        if nextTransactionStatus == false {
            bottomLineView.backgroundColor = Colors.veryLightPink
        }
        
    }
    
    func setDone() {
        topLineView.backgroundColor = Colors.vividBlue
        bottomLineView.backgroundColor = Colors.vividBlue
        checklistImageView.image = R.image.checklistDone()
    }
    
    func setUndone() {
        topLineView.backgroundColor = Colors.veryLightPink
        bottomLineView.backgroundColor = Colors.veryLightPink
        checklistImageView.image = nil
    }
    
}
