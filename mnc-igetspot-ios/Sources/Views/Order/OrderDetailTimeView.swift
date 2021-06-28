////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderDetailTimeViewDelegate:class {
    func closeTimeButtonDidClicked()
    func selectButtonDidClicked(selectedTime:Date?)
}

class OrderDetailTimeView: UIView {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!{
        didSet{
                    if #available(iOS 13.4, *) {
                        timePicker.preferredDatePickerStyle = .wheels
                    } else {
                        // Fallback on earlier versions
                    }
        }
    }
    weak var delegate: OrderDetailTimeViewDelegate?
    var selectedTime: Date?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonDidClicked() {
        delegate?.closeTimeButtonDidClicked()
    }
    
    @IBAction func selectButtonDidClicked() {
        delegate?.selectButtonDidClicked(selectedTime: timePicker.date)
    }
    
    @objc func dateChanged(sender : UIDatePicker) {
        print("datePicker?.date :\(sender.date.toFormat("HH:mm"))")
        
    }
    
    func setCurrentTime(time:Date) {
        timePicker.setDate(time, animated: true)
    }

    // MARK: - Private Function
    private func adjustLayout() {
        timePicker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        selectButton.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
        selectButton.makeItRounded(width: 0, cornerRadius: selectButton.frame.height/2)
        selectButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
}
