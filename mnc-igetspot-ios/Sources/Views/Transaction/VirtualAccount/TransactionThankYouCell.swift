//
//  TransactionThankYouCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/25/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class TransactionThankYouCell : MKTableViewCell {
    
    let confirmString = ", kami telah menerima pemesananmu."
    let orderIdString = "Invoice ID: "
    let csString = "Kamu bisa menghubungi i Get Spot dengan mengirimkan email ke "
    let csEmailString = "cs@igetspot.com "
    let telpString = "atau telepon ke "
    let phoneString = "+62 21 7303312"
    
    let mediumAttribute = [ NSAttributedString.Key.font: UIFont(name: "Barlow-Medium" , size: 14.0)!]
    let regularAttribute = [ NSAttributedString.Key.font: UIFont(name: "Barlow-Regular" , size: 14.0)!]
    let regularGreyAttribute = [ NSAttributedString.Key.font: UIFont(name: "Barlow-Regular" , size: 14.0)! , NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 102, green: 102, blue: 102) ]
    var mutableAttributedString : NSMutableAttributedString!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(invoiceId: String, userName: String, userEmail: String, isFromPushNotifications:Bool) {
        let name = NSMutableAttributedString(string: userName, attributes: mediumAttribute)
        let confirm = NSMutableAttributedString(string: confirmString, attributes: regularAttribute)
        mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(name)
        mutableAttributedString.append(confirm)
        nameLabel.attributedText = mutableAttributedString
        
        let order = NSMutableAttributedString(string: orderIdString, attributes: regularAttribute)
        let idorder = NSMutableAttributedString(string: invoiceId, attributes: mediumAttribute)
        mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(order)
        mutableAttributedString.append(idorder)
        orderIdLabel.attributedText = mutableAttributedString
        
        if (isFromPushNotifications) {
            logoImageView.image = R.image.thankYouPayment()
        } else {
            logoImageView.image = R.image.virtualAccountPayment()
        }
    }
    
}
