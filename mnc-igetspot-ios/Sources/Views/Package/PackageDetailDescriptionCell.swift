////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class PackageDetailDescriptionCell: MKTableViewCell {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setDescription(description: String){
        descLabel.text = description
    }
    
    func setDuration(duration:String?) {
        if let packageDuration = duration, packageDuration.isEmpty == false {
            durationLabel.text = "\(NSLocalizedString("Duration:", comment: "")) \(packageDuration)"
        } else {
            durationLabel.text = "\(NSLocalizedString("Duration:", comment: "")) \(NSLocalizedString("Not described", comment: ""))"
        }
    }

}
