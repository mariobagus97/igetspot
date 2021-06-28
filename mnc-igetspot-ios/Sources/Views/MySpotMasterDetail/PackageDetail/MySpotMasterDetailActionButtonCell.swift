////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterDetailActionButtonCellDelegate:class {
    func saveButtonDidClicked()
    func deleteButtonDidClicked()
}

class MySpotMasterDetailActionButtonCell: MKTableViewCell {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: GradientBorderButton!
    weak var delegate: MySpotMasterDetailActionButtonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.makeItRounded(width:0.0, cornerRadius : saveButton.bounds.height / 2)
        saveButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(Colors.vividBlue, for: .normal)
        deleteButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: deleteButton.bounds.height)
    }
    
    @IBAction func saveButtonDidClicked() {
        delegate?.saveButtonDidClicked()
    }
    
    @IBAction func deleteButtonDidClicked() {
        delegate?.deleteButtonDidClicked()
    }
    
}
