////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterDetailAboutCellDelegate: class{
    func editButtonDidClicked(aboutString:String?)
}

class MySpotMasterDetailAboutCell: MKTableViewCell {

    @IBOutlet weak var editAboutButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    weak var delegate: MySpotMasterDetailAboutCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setDescription(description: String){
        aboutLabel.text = description
    }
    
    @IBAction func editAboutButtonDidClicked() {
        delegate?.editButtonDidClicked(aboutString: aboutLabel.text)
    }
    
}
