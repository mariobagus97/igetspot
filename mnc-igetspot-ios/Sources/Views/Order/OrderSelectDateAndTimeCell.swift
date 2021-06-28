////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SwiftDate

protocol OrderSelectDateAndTimeCellDelegate:class {
    func showCalendar()
    func showTime()
}

class OrderSelectDateAndTimeCell: MKTableViewCell {
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    var delegate: OrderSelectDateAndTimeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGestures()
    }
    
    func setupTapGestures() {
        let dateTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDateTapped))
        dateTapGesture.cancelsTouchesInView = false
        dateView.isUserInteractionEnabled = true
        dateView.addGestureRecognizer(dateTapGesture)
        
        let timeTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTimeTapped))
        timeTapGesture.cancelsTouchesInView = false
        timeView.isUserInteractionEnabled = true
        timeView.addGestureRecognizer(timeTapGesture)
    }
    
    func setDate(dateString:String) {
        dateLabel.text = dateString
    }
    
    func setTime(timeString:String) {
        timeLabel.text = timeString
    }
    
    func getCurrentDate() -> Date? {
        guard let dateString = dateLabel.text, dateString != NSLocalizedString("Select date", comment: ""), let date = dateString.toDate("yyyy-MM-dd") else {
            return nil
        }
        
        return date.date
    }
    
    func getCurrentTime() -> Date? {
        guard let timeString = timeLabel.text, timeString != NSLocalizedString("Select time", comment: ""), let date = timeString.toDate("HH:mm") else {
            return nil
        }
        
        return date.date
    }
    
    @objc func handleDateTapped() {
        delegate?.showCalendar()
    }
    
    @objc func handleTimeTapped() {
        delegate?.showTime()
    }
}
