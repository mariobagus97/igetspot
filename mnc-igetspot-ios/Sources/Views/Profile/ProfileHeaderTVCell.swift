//
//  ProfileHeaderTVCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/25/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import Alamofire

protocol ProfileHeaderTVCellDelegate {
    func onProfilePhotoPressed()
    func onBackgroundPressed()
}

class ProfileHeaderTVCell : MKTableViewCell{
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userBalanceLabel: UILabel!
    @IBOutlet weak var userHeaderImage: UIImageView!
    
    var delegate : ProfileHeaderTVCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
        
        userPhoto.setRounded()
    }
    
    
    func setContent(user: UserData) {
        setBackground(image: user.backgroundProfile)
        setProfilePhoto(image: user.avatar)
        userNameLabel.text = user.firstname + " " + user.lastname
        userEmailLabel.text = user.email
        let totalBalanceString = "\(user.balance)".currency
        userBalanceLabel.text = "Balance: \(totalBalanceString)"
    }
    
    @IBAction func onProfilePhotoPressed(_ sender: Any) {
        self.delegate?.onProfilePhotoPressed()
    }
    
    @IBAction func onBackgroundPressed(_ sender: Any) {
        self.delegate?.onBackgroundPressed()
    }
    
    func setProfilePhoto(image: String) {
        let url = NSURL(string: image)
        let data = NSData(contentsOf:url as! URL)
           if data != nil {
            userPhoto.image = UIImage(data:data! as Data)
           }
    }
    
    func setBackground(image: String) {
        let url = NSURL(string: image)
        let data = NSData(contentsOf:url as! URL)
           if data != nil {
            userHeaderImage.image = UIImage(data:data! as Data)
           }
    }
}
