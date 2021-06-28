////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MarkerInfoView: UIView {

    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterOfLabel: UILabel!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeItRounded(width: 0, cornerRadius: 5)
        masterImageView.setRounded()
        callView.addDashedBorder(cornerRadius: callView.frame.size.height/2)
        chatView.addDashedBorder(cornerRadius: chatView.frame.size.height/2)
    }
    
    @IBAction func callButtonDidClicked() {
        
    }
    
    @IBAction func chatButtonDidClicked() {
        
    }

}
