////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol InfoMasterCellDelegate: class {
    func chatButtonDidClicked(masterId:String)
}

class InfoMasterCell: MKTableViewCell {
    
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterInfoLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var widthChatButtonConstraint: NSLayoutConstraint!
    weak var delegate: InfoMasterCellDelegate?
    var masterId:String?

    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        masterImageView.setRounded()
    }
    
    func setContent(masterName:String?, masterInfo:String?, masterImageUrl:String, masterId:String?) {
        masterNameLabel.text = masterName
        masterInfoLabel.text = masterInfo
        masterImageView.loadIGSImage(link: masterImageUrl, placeholderImage: R.image.userPlacaholder())
        self.masterId = masterId
    }
    
    func hideChatButton() {
        widthChatButtonConstraint.constant = 0
        layoutIfNeeded()
    }
    
    @IBAction func chatButtonDidClicked() {
        guard let masterId = self.masterId else {
            return
        }
        delegate?.chatButtonDidClicked(masterId: masterId)
    }
}
