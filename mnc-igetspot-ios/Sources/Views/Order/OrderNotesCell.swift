////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderNotesCellDelegate {
    func noteCellDidSelect()
}

class OrderNotesCell: MKTableViewCell {
    
    @IBOutlet weak var notesLabel: UILabel!
    var delegate: OrderNotesCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func onSelected() {
        delegate?.noteCellDidSelect()
    }
    
    func setContent(notes:String) {
        notesLabel.text = notes.isEmpty ? NSLocalizedString("Add Notes", comment: "") : notes
    }
    
    func getCurrentNotes() -> String {
        if notesLabel.text == NSLocalizedString("Add Notes", comment: "") {
            return ""
        }
        
        return notesLabel.text ?? ""
    }
    
}
