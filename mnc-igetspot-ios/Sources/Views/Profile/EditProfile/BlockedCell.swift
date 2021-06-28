//
//  BlockedCell.swift
//  mnc-igetspot-ios
//
//  Created by Handi Deyana on 02/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol BlockedCellDelegate: class {
    func cellDidSelect(master: BlockedMaster)
}

class BlockedCell : MKTableViewCell  {
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet var unblockText: UILabel!
    
    
    var master: BlockedMaster?
    weak var delegate: BlockedCellDelegate?

    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setContent(master:BlockedMaster){
        self.master = master
        userText.text = master.mastername
        let image:UIImage? = imageWith(name: master.mastername?.first?.description)
        imageUser.image = image
        imageUser.setRounded()
    }
    
    func imageWith(name: String?) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .purple
         nameLabel.textColor = .white
         nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
         nameLabel.text = name
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return nil
    }
    
    override func onSelected() {
        guard let masterFiltered = master else {
            return
        }
        delegate?.cellDidSelect(master: masterFiltered)
    }
}
