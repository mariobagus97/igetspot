////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftDate

protocol OrderDetailCalendarViewDelegate:class {
    func closeCalendarButtonDidClicked()
    func selectButtonDidClicked(selectedDate:Date?)
}

class OrderDetailCalendarView: UIView {
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthYearWidth: NSLayoutConstraint!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var monthWidth: NSLayoutConstraint!
    weak var delegate: OrderDetailCalendarViewDelegate?
    var changeableYear : Bool = false

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
    
    @IBAction func closeButtonDidClicked() {
        delegate?.closeCalendarButtonDidClicked()
    }
    
    @IBAction func selectButtonDidClicked() {
        let selectedDate = self.calendar.selectedDate
        delegate?.selectButtonDidClicked(selectedDate: selectedDate)
    }
    
    @IBAction func prevButtonDidClicked() {
        let date = self.calendar.currentPage
        let previousMonth = date.dateAt(.prevMonth)
        if (previousMonth.month >= calendar.minimumDate.month){
            self.monthField.text = previousMonth.monthString
            self.yearField.text = previousMonth.yearString
        }
        updateWidth()
        self.calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    @IBAction func nextButtonDidClicked() {
        let date = self.calendar.currentPage
        let nextMonth = date.dateAt(.nextMonth)
        if(changeableYear){
            if(!nextMonth.isInFuture){
                self.monthField.text = nextMonth.monthString
                self.yearField.text = nextMonth.yearString
                updateWidth()
                self.calendar.setCurrentPage(nextMonth, animated: true)
            }
        } else {
            self.monthField.text = nextMonth.monthString
            self.yearField.text = nextMonth.yearString
            updateWidth()
            self.calendar.setCurrentPage(nextMonth, animated: true)
        }
    }
    
    func setCurrentDate(date:Date) {
        self.calendar.select(date, scrollToDate: true)
    }
    
    func adjustLayout() {
        yearField.delegate = self
        selectButton.setTitle(NSLocalizedString("Select", comment: ""), for: .normal)
        selectButton.makeItRounded(width: 0, cornerRadius: selectButton.frame.height/2)
        selectButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        calendar.placeholderType = .none
        calendar.appearance.caseOptions = [.weekdayUsesUpperCase]
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.todayColor = Colors.blueTwo
        calendar.appearance.selectionColor = Colors.gradientThemeOne
        calendar.appearance.subtitleWeekendColor = Colors.brownishGrey
        calendar.appearance.titleWeekendColor = Colors.brownishGrey
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.weekdayFont = R.font.barlowBold(size: 12)
        calendar.appearance.headerTitleColor = Colors.blueTwo
        calendar.appearance.headerTitleFont = R.font.barlowMedium(size: 16)
        calendar.appearance.titleFont = R.font.barlowMedium(size: 14)
    }
    
    func setCalendarDate() {
        let date = self.calendar.currentPage
        self.calendar.select(Date(), scrollToDate: true)
        self.monthField.text = date.monthString
        self.yearField.text = date.yearString
        updateWidth()
    }
    
    func setChangeYearValue(changeableYear : Bool){
        self.changeableYear = changeableYear
        if (!changeableYear) {
            yearField.isUserInteractionEnabled = false
        } else {
            yearField.isUserInteractionEnabled = true
        }
    }
    
    func setBirthdate(date : String){
        if let chosenDate = Date(date) {
            self.monthField.text = chosenDate.monthString
            self.yearField.text = chosenDate.yearString
            monthWidth.constant = 100
            monthYearWidth.constant = monthWidth.constant + 40
            self.calendar.setCurrentPage(chosenDate, animated: false)
            self.calendar.select(chosenDate)
        }
    }
    
    func updateWidth(){
        let width = getWidth(text: monthField.text!)
        self.monthWidth.constant = 0.0
        if width > self.monthWidth.constant {
            monthWidth.constant = width
            monthYearWidth.constant = monthWidth.constant + 40
        }
        self.layoutIfNeeded()
    }
    
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UITextField(frame: .zero)
        txtField.font = R.font.barlowMedium(size: 16)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
}


// MARK: - FSCalendarDelegate
extension OrderDetailCalendarView: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(calendar.currentPage.toFormat("yyyy/MM/dd"))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(date.toFormat("yyyy/MM/dd"))")
        if monthPosition == .previous || monthPosition == .next {
            self.monthField.text = date.monthString
            self.yearField.text = date.yearString
            updateWidth()
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        self.layoutIfNeeded()
    }
}

// MARK: - FSCalendarDataSource
extension OrderDetailCalendarView: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        if (changeableYear){
            return Date("1950-01-01")!
        } else {
            return Date()
        }
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        if(changeableYear){
            return Date()
        }
        return calendar.maximumDate
    }
}

// MARK: - UITextFieldDelegate
extension OrderDetailCalendarView : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newSubjectString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let newCharacters = CharacterSet(charactersIn: newSubjectString as String)
        
        if !CharacterSet.decimalDigits.isSuperset(of: newCharacters) {
            /* New characters are not numeric characters */
            return false
        } else if newSubjectString.count > 4 {
            /* Year field too long - should only be 4 characters */
            return false
        } else if newSubjectString.count == 4 {
            /* Checks if the year is valid */
            textField.text = newSubjectString
            endEditing(true)
            
            let currentdate = self.calendar.currentPage
            var component = currentdate.dateComponents
            component.yearForWeekOfYear = Int(newSubjectString)
            component.year = Int(newSubjectString)
            let calendar = Calendar(identifier: .gregorian)
            if let date = calendar.date(from: component) {
                self.calendar.setCurrentPage(date, animated: true)
            }
            return true
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

extension Date {
    var monthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var yearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
}
