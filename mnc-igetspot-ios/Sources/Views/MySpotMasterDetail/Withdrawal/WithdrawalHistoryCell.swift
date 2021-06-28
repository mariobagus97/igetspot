////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class WithdrawalHistoryCell: MKTableViewCell {
    
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastBalanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setContent(withdrawalHistory:WithdrawalHistory) {
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//
//        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
//        print("Date",dateFormatterPrint.string(from: date!))

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss zzzz Z"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"

        let date: Date? = dateFormatterGet.date(from: withdrawalHistory.transactionDate!)
        print("Date",dateFormatterPrint.string(from: date!))


        
        
        
        transactionNameLabel.text = withdrawalHistory.transactionName
        idLabel.text = withdrawalHistory.inoviceId
        dateLabel.text = dateFormatterPrint.string(from: date!)
        var symbolTransactionString = ""
        if let transactionActivity = withdrawalHistory.transactionActivity {
            if (transactionActivity == "IN") {
                symbolTransactionString = "+"
            } else if (transactionActivity == "OUT") {
                symbolTransactionString = "-"
            }
        }
        transactionAmountLabel.text = "\(symbolTransactionString)\(withdrawalHistory.transactionAmount?.currency ?? "0")"
        
        let balance = (withdrawalHistory.lastBalance ?? "0").currency
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "Balance: \(balance)")
        attributedString.setColorForText(textForAttribute: balance, withColor: Colors.brownishGrey, withFont: R.font.barlowRegular(size: 12))
        lastBalanceLabel.attributedText = attributedString
    }
    
}
