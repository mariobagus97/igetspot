//
//  AboutPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/1/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol AboutPageDelegate: class {
    func openIg()
    func openTwitter()
    func openFB()
}

class AboutPage: UIView {
    
    @IBOutlet weak var connectFb: UIImageView!
    @IBOutlet weak var connectIg: UIImageView!
    @IBOutlet weak var connectYoutube: UIImageView!
    @IBOutlet weak var connectTwitter: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    weak var delegate : AboutPageDelegate!
    
    let attributedString = NSMutableAttributedString(string: "Tailored for your need\n\r\nCustomize your needs by filtering the services on demand based on price, location, and expertise.\n\n\r\nYour talent, your opportunities\n\r\nWe believe everyone has their own expertise. Create your own portofolio and expand your professional horizon.\n\n\r\nSafe and handy\n\r\nAll payment and warrant systems are made as safe as possible for both parties. Every transaction can be done in one app: from browsing, discussing, dealing, and payment.\r\n", attributes: [
        .font: UIFont(name: "Barlow-Regular", size: 14.0)!,
        .foregroundColor: UIColor.rgb(red: 102, green: 102, blue: 102),
        .kern: 0.0
        ])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        setAboutText()
        addGesture()
    }
    
    
    func setAboutText(text : String){
        self.aboutLabel.setHTMLFromString(text: text)
        setNeedsLayout()
        layoutIfNeeded()
        
        
        print("about attr: \(text.htmlToAttributedString)")
    }
    
    func addGesture(){
        connectIg.isUserInteractionEnabled = true
        connectIg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onIgPressed(_:))))
        
        connectTwitter.isUserInteractionEnabled = true
        connectTwitter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTwitterPressed(_:))))
        
        connectFb.isUserInteractionEnabled = true
        connectFb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFBPressed(_:))))
    }
    
    @objc func onIgPressed(_ sender: UITapGestureRecognizer){
       delegate?.openIg()
    }
    
    @objc func onTwitterPressed(_ sender: UITapGestureRecognizer){
        delegate?.openTwitter()
    }
    
    @objc func onFBPressed(_ sender: UITapGestureRecognizer){
        delegate?.openFB()
    }
}
