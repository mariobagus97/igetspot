////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderDetailNotesVCDelegate:class {
    func addButtonDidClicked(noteString: String)
    func closeNotesButtonDidClicked()
}

class OrderDetailNotesVC: MKViewController {
    
    var orderDetailNotesView: OrderDetailNotesView!
    var noteString: String = ""
    weak var delegate:OrderDetailNotesVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setContent()
        hideKeyboardWhenTappedAround() 
    }
    
    func addViews() {
        orderDetailNotesView = OrderDetailNotesView()
        orderDetailNotesView.delegate = self
        view.addSubview(orderDetailNotesView)
        
        orderDetailNotesView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    func setContent() {
        orderDetailNotesView.setContent(noteString: noteString)
        
    }

}

extension OrderDetailNotesVC: OrderDetailNotesViewDelegate {
    func addButtonDidClicked(noteString: String) {
        delegate?.addButtonDidClicked(noteString: noteString)
    }
    
    func closeNotesButtonDidClicked() {
        delegate?.closeNotesButtonDidClicked()
    }
}
