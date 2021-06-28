////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderDetailCalendarVCDelegate:class {
    func closeCalanderButtonDidClicked()
    func selectDateCalendarDidClicked(selectedDate:Date?)
}

class OrderDetailCalendarVC: MKViewController {

    var orderDetailCalendarView: OrderDetailCalendarView!
    var currentDate:Date?
    weak var delegate: OrderDetailCalendarVCDelegate?
    var changeableYear: Bool = false
    var birthDate : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        hideKeyboardWhenTappedAround()
    }

    func addViews() {
        orderDetailCalendarView = OrderDetailCalendarView()
        orderDetailCalendarView.delegate = self
        orderDetailCalendarView.setChangeYearValue(changeableYear : changeableYear)
        if let date = self.currentDate {
            orderDetailCalendarView.setCurrentDate(date: date)
        }
        view.addSubview(orderDetailCalendarView)
        print("calendarbirth \(changeableYear)")

        orderDetailCalendarView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (birthDate != nil && birthDate != "") {
            orderDetailCalendarView.setBirthdate(date: birthDate)
        } else {
            orderDetailCalendarView.setCalendarDate()
        }
    }
    
}

// MARK: - OrderDetailCalendarViewDelegate
extension OrderDetailCalendarVC: OrderDetailCalendarViewDelegate {
    func selectButtonDidClicked(selectedDate:Date?) {
        delegate?.selectDateCalendarDidClicked(selectedDate: selectedDate)
    }
    
    func closeCalendarButtonDidClicked() {
        delegate?.closeCalanderButtonDidClicked()
    }
    
}
