//
//  TransactionPaymentConfirmCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/25/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
 
class TransactionPaymentConfirmCell : MKTableViewCell {
    let dueDateString = "Silakan lakukan pembayaran ke salah satu nomor rekening i Get Spot yang tertera dibawah ini sebelum "
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rekeningLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!

    @IBOutlet weak var CopyVALabel: UILabel!
    var mutableAttributedString : NSMutableAttributedString!
    
    
    let mediumAttribute = [ NSAttributedString.Key.font: UIFont(name: "Barlow-Medium" , size: 14.0)! ]
    let regularAttribute = [ NSAttributedString.Key.font: UIFont(name: "Barlow-Regular" , size: 14.0)!, NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 102, green: 102, blue: 102) ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CopyVALabel.isUserInteractionEnabled = true
   
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(copyVAnumber) )
//        tapgesture.numberOfTapsRequired = 1
        CopyVALabel.addGestureRecognizer(tapgesture)
        
        
        if #available(iOS 13.0, *) {
            let hover = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
            rekeningLabel.addGestureRecognizer(hover)
        } else {
            // Fallback on earlier versions
        }

       
       
        
    }
    
    
    func setContent(duedate: String, accountNo: String, bankName: String){
        let stringConfirm = NSMutableAttributedString(string: dueDateString, attributes: regularAttribute)
        let date = NSMutableAttributedString(string: duedate, attributes: mediumAttribute)
        mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(stringConfirm)
        mutableAttributedString.append(date)
        dateLabel.attributedText = mutableAttributedString

        rekeningLabel.text = accountNo
        bankNameLabel.text = bankName
    }
    
    @objc func copyVAnumber() {
        UIPasteboard.general.string =  rekeningLabel.text
        CopyVALabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        CopyVALabel.text = "VA Number has copied"
    }
    
    @available(iOS 13.0, *)
    @objc
      func hovering(_ recognizer: UIHoverGestureRecognizer) {
          switch recognizer.state {
          case .began, .changed:
            rekeningLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
          case .ended:
            rekeningLabel.textColor = UIColor.link
          default:
              break
          }
      }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
   
 
    

