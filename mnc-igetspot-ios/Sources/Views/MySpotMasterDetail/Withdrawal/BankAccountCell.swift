////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class BankAccountCell: MKTableViewCell {
    
    @IBOutlet weak var bankAccountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setContent(accountHolderName:String, accountBankNumber:String, bankName:String) {
        bankAccountLabel.text = "\(accountHolderName) / \(accountBankNumber) / \(bankName)"
    }
}
