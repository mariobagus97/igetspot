////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderSelectLocationCellDelegate:class {
    func selectLocationDidSelect()
}

class OrderSelectLocationCell: MKTableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    weak var delegate: OrderSelectLocationCellDelegate?
    var googlePlace:GooglePlace?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func onSelected() {
        delegate?.selectLocationDidSelect()
    }
    
    func setContent(place:GooglePlace) {
        googlePlace = place
        locationLabel.text = place.description
    }
    
    func getCurrentLocation() -> GooglePlace? {
        guard let place = self.googlePlace else {
            return nil
        }
        return place
    }

}
