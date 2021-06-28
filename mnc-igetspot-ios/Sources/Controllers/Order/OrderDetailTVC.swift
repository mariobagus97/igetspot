////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import FloatingPanel
import SwiftDate

class OrderDetailTVC: MKTableViewController {
    
    var packageId: String?
    var orderDetail: OrderDetail!
    var contentSection: MKTableViewSection!
    var orderDetailMasterCell: OrderDetailMasterCell!
    var orderSelectDateAndTimeCell: OrderSelectDateAndTimeCell!
    var orderSelectLocationCell: OrderSelectLocationCell!
    var orderNotesCell: OrderNotesCell!
    var packageOrderCell: PackageDetailOrderCell!
    var addNotesFPC: FloatingPanelController?
    var selectCalendarFPC: FloatingPanelController?
    var selectTimeFPC: FloatingPanelController?
    var presenter = OrderDetailPresenter()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter.attachview(self)
        setContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Order", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.orderDetailMasterCell.name,
            R.nib.orderSelectDateAndTimeCell.name,
            R.nib.orderSelectLocationCell.name,
            R.nib.orderNotesCell.name,
            R.nib.orderSectionHeaderCell.name,
            R.nib.orderInformationCell.name,
            R.nib.packageDetailOrderCell.name,
            ])
    }
    
    override func createSections() {
        super.createSections()
        contentSection = MKTableViewSection()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
        createOrderDetailMasterCell()
        createOrderSelectDateAndTimeCell()
        createOrderSelectLocationCell()
        createOrderNotesCell()
        createPackageOrderCell()
    }
    
    // MARK: - Private Functions
    private func createOrderDetailMasterCell() {
       orderDetailMasterCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderDetailMasterCell.name) as? OrderDetailMasterCell
    }
    
    private func createOrderSelectDateAndTimeCell() {
        orderSelectDateAndTimeCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderSelectDateAndTimeCell.name) as? OrderSelectDateAndTimeCell
        orderSelectDateAndTimeCell.delegate = self
    }
    
    private func createOrderSelectLocationCell() {
        orderSelectLocationCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderSelectLocationCell.name) as? OrderSelectLocationCell
        orderSelectLocationCell.delegate = self
    }
    
    private func createOrderNotesCell() {
        orderNotesCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderNotesCell.name) as? OrderNotesCell
        orderNotesCell.delegate = self
    }
    
    private func createOrderSectionHeaderCell() -> OrderSectionHeaderCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderSectionHeaderCell.name) as! OrderSectionHeaderCell
    }
    
    private func createOrderInformationCell() -> OrderInformationCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderInformationCell.name) as! OrderInformationCell
    }
    
    private func createPackageOrderCell() {
        packageOrderCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageDetailOrderCell.name) as? PackageDetailOrderCell
        packageOrderCell.delegate = self
    }
    
    private func setContent() {
        contentSection.appendRow(cell: orderDetailMasterCell)
        contentSection.appendRow(cell: orderSelectDateAndTimeCell)
        contentSection.appendRow(cell: orderSelectLocationCell)
        contentSection.appendRow(cell: orderNotesCell)
        
        orderDetailMasterCell.setContent(masterImageUrl: orderDetail.masterImageurl ?? "", masterName: orderDetail.masterName ?? "", packageName: orderDetail.packageName ?? "")
        
        // Order Information
        let orderInformationSectionCell = createOrderSectionHeaderCell()
        orderInformationSectionCell.titleLabel.text = NSLocalizedString("Order Information", comment: "")
        contentSection.appendRow(cell: orderInformationSectionCell)
        // Name
        let nameCell = createOrderInformationCell()
        nameCell.titleLabel.text = NSLocalizedString("Name", comment: "")
        nameCell.valueLabel.text = orderDetail.userFullName
        contentSection.appendRow(cell: nameCell)
        
        // Email
        let emailCell = createOrderInformationCell()
        emailCell.titleLabel.text = NSLocalizedString("Email", comment: "")
        emailCell.valueLabel.text = orderDetail.userEmail
        contentSection.appendRow(cell: emailCell)
        
        // Phone Number
        let phoneNumberCell = createOrderInformationCell()
        phoneNumberCell.titleLabel.text = NSLocalizedString("Phone Number", comment: "")
        phoneNumberCell.valueLabel.text = orderDetail.userPhone
        phoneNumberCell.separatorView.alpha = 0.0
        contentSection.appendRow(cell: phoneNumberCell)
        
        // Order Resume
        let orderResumeSectionCell = createOrderSectionHeaderCell()
        orderResumeSectionCell.titleLabel.text = NSLocalizedString("Order Resume", comment: "")
        contentSection.appendRow(cell: orderResumeSectionCell)
        
        // Price
        let priceCell = createOrderInformationCell()
        priceCell.titleLabel.text = NSLocalizedString("Price", comment: "")
        priceCell.valueLabel.font = R.font.barlowMedium(size: 18)
        priceCell.valueLabel.text = orderDetail.packagePrice?.currency
        priceCell.separatorView.alpha = 0.0
        contentSection.appendRow(cell: priceCell)
        
        packageOrderCell.orderButton.setTitle(NSLocalizedString("Order Now", comment: ""), for: .normal)
        contentSection.appendRow(cell: packageOrderCell)
        
        contentView.reloadData()
    }
    
    private func showAddNotesPageFPC(noteString:String) {
        addNotesFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        addNotesFPC?.surfaceView.cornerRadius = 8.0
        addNotesFPC?.surfaceView.shadowHidden = false
        addNotesFPC?.isRemovalInteractionEnabled = true
        addNotesFPC?.delegate = self
        
        let contentVC = OrderDetailNotesVC()
        contentVC.delegate = self
        contentVC.noteString = noteString
        // Set a content view controller
        addNotesFPC?.set(contentViewController: contentVC)
        present(addNotesFPC!, animated: true, completion: nil)
    }
    
    private func showSelectCalendar(currentDate:Date?) {
        selectCalendarFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        selectCalendarFPC?.surfaceView.cornerRadius = 8.0
        selectCalendarFPC?.surfaceView.shadowHidden = false
        selectCalendarFPC?.isRemovalInteractionEnabled = true
        selectCalendarFPC?.delegate = self
        
        let contentVC = OrderDetailCalendarVC()
        contentVC.currentDate = currentDate
        contentVC.delegate = self
        // Set a content view controller
        selectCalendarFPC?.set(contentViewController: contentVC)
        present(selectCalendarFPC!, animated: true, completion: nil)
    }
    
    private func showSelectTime(currentTime:Date?) {
        selectTimeFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        selectTimeFPC?.surfaceView.cornerRadius = 8.0
        selectTimeFPC?.surfaceView.shadowHidden = false
        selectTimeFPC?.isRemovalInteractionEnabled = true
        selectTimeFPC?.delegate = self
        
        let contentVC = OrderDetailTimeVC()
        contentVC.currentTime = currentTime
        contentVC.delegate = self
        
        // Set a content view controller
        selectTimeFPC?.set(contentViewController: contentVC)
        self.present(selectTimeFPC!, animated: true, completion: nil)
    }
    
    private func hideAddNotesFPC(animated:Bool) {
        if let addNotesFPC = self.addNotesFPC {
            addNotesFPC.dismiss(animated: animated, completion: nil)
        }
    }
    
    private func hideSelectCalendarFPC(animated:Bool) {
        if let selectCalendarFPC = self.selectCalendarFPC {
            selectCalendarFPC.dismiss(animated: animated, completion: nil)
        }
    }
    
    private func hideSelectTimeFPC(animated:Bool) {
        if let selectTimeFPC = self.selectTimeFPC {
            selectTimeFPC.dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - OrderDetailView
extension OrderDetailTVC: OrderDetailView {
    func showOrderLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideOrderLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
    func handleOrderSuccess() {
        NotificationCenter.default.post(name: NSNotification.Name(kRefreshDataRequestOrderNotificationName), object: nil)
        self.showSuccessMessageBanner(NSLocalizedString("This package was successfully added to your order", comment: ""))
        self.navigationController?.popToRootViewController(animated: false)
        if let mainTabBarController = UIApplication.getMainPageTabBarController() {
            mainTabBarController.selectedIndex =  TabBarIndex.order
            let navigationController = mainTabBarController.selectedViewController as? UINavigationController
            if let orderPagerVC = navigationController?.viewControllers.first as? OrderVC {
                if (orderPagerVC.pagingViewController != nil) {
                    orderPagerVC.openRequestTabAndRefreshData()
                }
            }
        }
    }
}

// MARK:- OrderDetailCalendarVCDelegate
extension OrderDetailTVC: OrderDetailCalendarVCDelegate {
    func closeCalanderButtonDidClicked() {
        hideSelectCalendarFPC(animated: true)
    }
    
    func selectDateCalendarDidClicked(selectedDate:Date?) {
        hideSelectCalendarFPC(animated: true)
        guard let date = selectedDate else {
            orderSelectDateAndTimeCell.setDate(dateString: NSLocalizedString("Select date", comment: ""))
            return
        }
        orderSelectDateAndTimeCell.setDate(dateString: date.toFormat("yyyy-MM-dd"))
    }
}

// MARK:- OrderDetailTimeVCDelegate
extension OrderDetailTVC: OrderDetailTimeVCDelegate {
    func closeTimeButtonDidClicked() {
        hideSelectTimeFPC(animated: true)
    }
    
    func selectTimeDidClicked(selectedTime: Date?) {
        hideSelectTimeFPC(animated: true)
        guard let date = selectedTime else {
            orderSelectDateAndTimeCell.setTime(timeString: NSLocalizedString("Select time", comment: ""))
            return
        }
        orderSelectDateAndTimeCell.setTime(timeString: date.toFormat("HH:mm"))
    }
}

// MARK:- OrderDetailNotesVCDelegate
extension OrderDetailTVC: OrderDetailNotesVCDelegate {
    func addButtonDidClicked(noteString: String) {
        hideAddNotesFPC(animated: true)
        orderNotesCell.setContent(notes: noteString)
    }
    
    func closeNotesButtonDidClicked() {
        hideAddNotesFPC(animated: true)
    }
    
}

// MARK:- OrderNotesCellDelegate
extension OrderDetailTVC: OrderNotesCellDelegate {
    func noteCellDidSelect() {
        let notes = orderNotesCell.getCurrentNotes()
        showAddNotesPageFPC(noteString: notes)
    }
}

// MARK:- FloatingPanelControllerDelegate
extension OrderDetailTVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == selectCalendarFPC || vc == selectTimeFPC {
            return IntrinsicPanelLayout()
        } else if vc == addNotesFPC {
            return FullPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if vc == addNotesFPC {
            addNotesFPC = nil
        }
    }
}

// MARK: - PackageDetailOrderCellDelegate
extension OrderDetailTVC: PackageDetailOrderCellDelegate {
    func orderButtonDidClicked() {
        guard let packageId = self.packageId, let place = orderSelectLocationCell.getCurrentLocation(), let address = place.description, let latitude = place.latitude, let longitude = place.longitude, orderNotesCell.getCurrentNotes().isEmptyOrWhitespace() == false, let time = orderSelectDateAndTimeCell.getCurrentTime(), let date = orderSelectDateAndTimeCell.getCurrentDate() else {
            self.showErrorMessageBanner(NSLocalizedString("Please fill all fields", comment: ""))
            return
        }
        
        let timeString = time.toFormat("HH:mm:ss")
        let dateString = date.toFormat("yyyy-MM-dd")
        let latLong = "\(latitude)#\(longitude)"
        let notes = orderNotesCell.getCurrentNotes()
        let region = Date().convertTo(region: .local)
        let currentDate = region.date
        let dateUpdated = "\(String(dateString)) \(String(timeString))"
        let selectedDate = dateUpdated.toDate()?.date
        print("theDate \(dateUpdated)")
        
        if  ((selectedDate ?? Date()) < currentDate){
            showErrorMessageBanner(NSLocalizedString("Ooops,the date and time your input is not valid, please check again..", comment: ""))
        } else {
            presenter.requestOrderAdd(packageId: packageId, address: address, latlong: latLong, date: dateString, time: timeString, notes: notes)
        }
        
    }
}


// MARK: - OrderSelectDateAndTimeCellDelegate
extension OrderDetailTVC: OrderSelectDateAndTimeCellDelegate {
    func showCalendar() {
        let currentDate = orderSelectDateAndTimeCell.getCurrentDate()
        showSelectCalendar(currentDate: currentDate)
    }
    
    func showTime() {
        let currentTime = orderSelectDateAndTimeCell.getCurrentTime()
        showSelectTime(currentTime: currentTime)
    }
}

// MARK: - OrderSelectLocationCellDelegate
extension OrderDetailTVC: OrderSelectLocationCellDelegate {
    func selectLocationDidSelect() {
        let selectLocationVC = OrderDetailSelectLocationVC()
        selectLocationVC.delegate = self
        if let currentPlace = orderSelectLocationCell.getCurrentLocation() {
            selectLocationVC.currentPlace = currentPlace
        }
        self.navigationController?.pushViewController(selectLocationVC, animated: true)
    }
}

// MARK: - OrderDetailSelectLocationVCDelegate
extension OrderDetailTVC: OrderDetailSelectLocationVCDelegate {
    func locationDidSelect(place: GooglePlace) {
        orderSelectLocationCell.setContent(place: place)
        contentView.reloadData()
    }
}

class FullPanelLayout: FloatingPanelLayout {
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .hidden]
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 10.0 // A top inset from safe area
        case .hidden: return nil
        default: return nil // Or `case .hidden: return nil`
        }
    }
}
