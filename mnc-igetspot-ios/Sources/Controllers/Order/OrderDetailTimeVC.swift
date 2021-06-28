////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderDetailTimeVCDelegate:class {
    func closeTimeButtonDidClicked()
    func selectTimeDidClicked(selectedTime:Date?)
}

class OrderDetailTimeVC: MKViewController {
    
    var orderDetailTimeView: OrderDetailTimeView!
    weak var delegate: OrderDetailTimeVCDelegate?
    var currentTime:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
    }
    
    func addViews() {
        orderDetailTimeView = OrderDetailTimeView()
        orderDetailTimeView.delegate = self
        if let time = self.currentTime {
            orderDetailTimeView.setCurrentTime(time: time)
        }
        
        view.addSubview(orderDetailTimeView)
        orderDetailTimeView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }

}

// MARK: - OrderDetailCalendarViewDelegate
extension OrderDetailTimeVC: OrderDetailTimeViewDelegate {
    func selectButtonDidClicked(selectedTime: Date?) {
        delegate?.selectTimeDidClicked(selectedTime: selectedTime)
    }
    
    func closeTimeButtonDidClicked() {
        delegate?.closeTimeButtonDidClicked()
    }
}
