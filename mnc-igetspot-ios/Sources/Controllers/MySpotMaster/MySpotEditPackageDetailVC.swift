////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import MXParallaxHeader
import DKImagePickerController
import SwiftMessages

protocol MySpotEditPackageDetailVCDelegate {
    func deletePackageSuccess()
}

class MySpotEditPackageDetailVC: MKViewController, MKTableViewDelegate {
    
    var mPresenter = MySpotMasterPackageDetailPresenter()
    var headerView : MySpotMasterDetailHeaderView!
    var contentView : MKTableView!
    var infoCell: MySpotMasterInfoCell!
    var descriptionCell: MySpotMasterDetailAboutCell!
    var packagePortofolioCell : MySpotPackagePortofolioCell!
    var actionButtonCell : MySpotMasterDetailActionButtonCell!
    var emptyCell : IGSEmptyCell!
    var loadingCell: LoadingCell!
    var scrollView : MXScrollView!
    var contentSection: MKTableViewSection!
    var parallaxHeaderHeight:CGFloat = 140
    var imagePortofolioArray:[MySpotPackageImage]?
    var packageId:String?
    var delegate: MySpotEditPackageDetailVCDelegate?
    var deleteParameter : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        adjustLayout()
        addScrollView()
        mPresenter.attachview(self)
        getPackageDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func tryAgainButtonDidClicked() {
        super.tryAgainButtonDidClicked()
        
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("Edit Package", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }

    // MARK: - MKTableViewDelegate
    func createRows() {
        createPackageInfoCell()
        createPackageDescriptionCell()
        createPackagePortofolioCell()
        createPackageOrderCell()
    }
    
    func createSections() {
        contentSection = MKTableViewSection()
        contentView.appendSection(contentSection)
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.mySpotMasterInfoCell.name,
            R.nib.mySpotPackagePortofolioCell.name,
            R.nib.mySpotMasterDetailAboutCell.name,
            R.nib.mySpotMasterDetailActionButtonCell.name,
            R.nib.igsEmptyCell.name,
            R.nib.loadingCell.name
            ])
    }
    
    // MARK: - Private Methods
    private func createPackageDescriptionCell() {
        descriptionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotMasterDetailAboutCell.name) as? MySpotMasterDetailAboutCell
    }
    
    private func createPackagePortofolioCell() {
        packagePortofolioCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotPackagePortofolioCell.name) as? MySpotPackagePortofolioCell
        packagePortofolioCell.loadView()
    }
    
    private func createPackageInfoCell() {
        infoCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotMasterInfoCell.name) as? MySpotMasterInfoCell
        infoCell.delegate = self
    }
    
    private func createPackageOrderCell() {
        actionButtonCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotMasterDetailActionButtonCell.name) as? MySpotMasterDetailActionButtonCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func addScrollView() {
        headerView = MySpotMasterDetailHeaderView()
        
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        
        parallaxHeaderHeight = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? parallaxHeaderHeight - 20 : parallaxHeaderHeight
        scrollView = MXScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = parallaxHeaderHeight
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints{ (make) in
            make.left.right.equalTo(scrollView)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo((scrollView.parallaxHeader.view?.snp.bottom)!).offset(0)
            make.height.equalTo(self.view.frame.height - self.scrollView.frame.height - self.topbarHeight)
        }
    }
    
    private func showPicker () {
        let pickerController = DKImagePickerController()
        pickerController.UIDelegate = CustomUIDKImagePickerDelegate()
        pickerController.showsCancelButton = true
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage { (image, info) in
                    if let img = image {
                        let packageImage = MySpotPackageImage()
                        packageImage.image = img
                        packageImage.imageId = nil
                        packageImage.imageUrl = nil
                        self.appendPortofolioImage(packageImage: packageImage)
                        
                        self.deleteParameter.append(img.jpgToBase64String())
                    }
                }
            }
        }
        
        let maxPackageImage = 10
        var currentTotalPackage = 0
        if let packageImageArray = self.imagePortofolioArray {
            currentTotalPackage = packageImageArray.count
        }
        pickerController.maxSelectableCount = maxPackageImage - currentTotalPackage
        self.present(pickerController, animated: true) {}
    }
    
    private func appendPortofolioImage(packageImage:MySpotPackageImage) {
        self.imagePortofolioArray?.append(packageImage)
        setContentPortofolio()
    }
    
    private func setContentPortofolio() {
        if let imagePortofolioArray = self.imagePortofolioArray {
            self.imagePortofolioArray = imagePortofolioArray
            self.packagePortofolioCell.setContent(packagePortofolios: imagePortofolioArray)
            self.contentView.reloadData()
        }
    }
    
    private func processDeletePackage() {
        if let packageId = self.packageId {
            mPresenter.deletePackageDetail(packageId: packageId)
        }
    }
    
    // MARK: - Public Functions
    func getPackageDetail() {
        guard let packageId = self.packageId else {
            return
        }
        mPresenter.getPackageDetail(packageId: packageId)
    }
}

// MARK: - MySpotEditPackageDetailView
extension MySpotEditPackageDetailVC: MySpotEditPackageDetailView {
    func showPackageDetailLoadingHUD(message: String?) {
        showLoadingHUD(message)
    }
    
    func hidePackageDetailLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageSuccess(message: String) {
        showSuccessMessageBanner(message)
    }
    
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
    func requestPackageDetail() {
        getPackageDetail()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        scrollView.isScrollEnabled = false
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func showLoadingView() {
        scrollView.isScrollEnabled = false
        contentSection.removeAllRows()
        createLoadingCell()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(300)
        loadingCell.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentView.reloadData()
        }
    }
    
    func hideLoadingView() {
        contentSection.removeAllRows()
    }
    
    func setContent(packageDetail : MySpotPackageDetail) {
        scrollView.isScrollEnabled = true
        contentSection.appendRow(cell: infoCell)
        contentSection.appendRow(cell: descriptionCell)
        
        infoCell.setContent(packageDetail: packageDetail)
        descriptionCell.editAboutButton.setTitle(NSLocalizedString("Edit Description", comment: ""), for: .normal)
        descriptionCell.aboutLabel.text = packageDetail.packageDescription
        descriptionCell.delegate = self
        
        createPackagePortofolioCell()
        packagePortofolioCell.delegate = self
        packagePortofolioCell.titleLabel.text = NSLocalizedString("Package Portfolio", comment: "")
        contentSection.appendRow(cell: packagePortofolioCell)
        contentSection.appendRow(cell: actionButtonCell)
        actionButtonCell.delegate = self
        actionButtonCell.setNeedsLayout()
        actionButtonCell.layoutIfNeeded()
        
        if let packagePortofolios = packageDetail.packagePortofolios, packagePortofolios.count > 0  {
            let packagePortofolio = packagePortofolios[0]
            headerView.setImageHeader(withUrlString: packagePortofolio.imageUrl ?? "")
            self.imagePortofolioArray = packagePortofolios
            packagePortofolioCell.setContent(packagePortofolios: packagePortofolios)
        }
        contentView.reloadData()
    }
    
    func setDescriptionPackage(content:String) {
        descriptionCell.aboutLabel.text = content
        contentView.reloadData()
    }
    
    func setPackagePrice(price:String) {
        infoCell.setPackagePrice(packagePrice: price)
        contentView.reloadData()
    }
    
    func handleSuccessDelete() {
        delegate?.deletePackageSuccess()
        navigationController?.popViewController(animated: true)
    }
    
    func popSelf(){
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - IGSEmptyCellDelegate
extension MySpotEditPackageDetailVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            getPackageDetail()
        }
    }
}

// MARK: - PackageDetailPortofolioCellDelegate
extension MySpotEditPackageDetailVC: MySpotPackagePortofolioCellDelegate {
    func deleteButtonPortofolioDidClicked(packagePortofolio: MySpotPackageImage) {
        if let imageId = packagePortofolio.imageUrl {
            deleteParameter.append(imageId)
            self.imagePortofolioArray?.removeAll(where: {$0.imageUrl == imageId})
            
            
        } else if let image = packagePortofolio.image {
            if let indexImages = deleteParameter.firstIndex(of: image.jpgToBase64String()){
                deleteParameter.remove(at: indexImages)
            }
            self.imagePortofolioArray?.removeAll(where: {$0.image == image})
        }
        
        setContentPortofolio()
    }
    
    func packagePortofolioDidClicked(packagePortofolio:MySpotPackageImage, index:Int) {
        if let pathImageUrl = packagePortofolio.imageUrl, pathImageUrl.isEmpty == false {
            let fullImageUrl = IGSImageUrlHelper.getImageUrl(forPathUrl: pathImageUrl)
            IGSLightbox.show(imageSrcs: [fullImageUrl])
        }
        
    }
    
    func addPackagePortofolioDidClicked() {
        showPicker()
    }
}

// MARK: - MySpotMasterDetailAboutCellDelegate
extension MySpotEditPackageDetailVC: MySpotMasterDetailAboutCellDelegate {
    func editButtonDidClicked(aboutString:String?) {
        if let topVC = UIApplication.getTopMostViewController() {
            let mySpotEditVC = MySpotEditVC()
            mySpotEditVC.aboutTextString = aboutString ?? ""
            mySpotEditVC.delegate = self
            mySpotEditVC.title = NSLocalizedString("Edit Description", comment: "")
            let navController = UINavigationController(rootViewController: mySpotEditVC)
            topVC.present(navController, animated: true, completion: nil)
        }
    }
}

// MARK: - MySpotEditVCDelegate
extension MySpotEditPackageDetailVC: MySpotEditVCDelegate {
    func saveButtonDidClicked(content: String, editVC:MySpotEditVC) {
        editVC.dismiss(animated: true, completion: { [weak self] in
            self?.setDescriptionPackage(content: content)
        })
    }
}

// MARK: - MySpotMasterDetailActionButtonCellDelegate
extension MySpotEditPackageDetailVC: MySpotMasterDetailActionButtonCellDelegate {
    func saveButtonDidClicked() {
        guard let packageId = self.packageId, let packageDescription = descriptionCell.aboutLabel.text, packageDescription.isEmptyOrWhitespace() == false, let packagePrice = infoCell.getPackagePrice(), packagePrice != "0", let portofolioImageArray = self.imagePortofolioArray,
        portofolioImageArray.count > 0 else {
            self.showAlertMessage(title: NSLocalizedString("Edit Package Error", comment: ""), message: NSLocalizedString("Description, Price and Portofolio images cannot be empty", comment: ""), iconImage: nil, okButtonTitle: NSLocalizedString("Ok", comment: ""), okAction: {
                SwiftMessages.hide()
            }, cancelButtonTitle: nil, cancelAction: nil)
            return
        }
        
        self.showAlertMessage(title: NSLocalizedString("Save Package", comment: ""), message: NSLocalizedString("Are you sure to save this changed ?", comment: ""), iconImage: nil, okButtonTitle: NSLocalizedString("Save", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               
                self?.mPresenter.editPackageDetails(packageId: packageId, description: packageDescription, packagePrice: packagePrice, packagePortofolioArray: self!.deleteParameter)
                
            }
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
    
    func deleteButtonDidClicked() {
        self.showAlertMessage(title: NSLocalizedString("Delete Package", comment: ""), message: NSLocalizedString("Are you sure to delete this package ?", comment: ""), iconImage: nil, okButtonTitle: NSLocalizedString("Delete", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.processDeletePackage()
            }
            
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
}

// MARK: - MySpotMasterInfoCellDelegate
extension MySpotEditPackageDetailVC: MySpotMasterInfoCellDelegate {
    func editPackagePrice(currentPrice: String) {
        if let topVC = UIApplication.getTopMostViewController() {
            let mySpotEditPackagePriceVC = MySpotEditPackagePriceVC()
            mySpotEditPackagePriceVC.price = currentPrice
            mySpotEditPackagePriceVC.delegate = self
            mySpotEditPackagePriceVC.title = NSLocalizedString("Edit Price", comment: "")
            let navController = UINavigationController(rootViewController: mySpotEditPackagePriceVC)
            topVC.present(navController, animated: true, completion: nil)
        }
    }
}

// MARK: - MySpotEditPackagePriceVCDelegate
extension MySpotEditPackageDetailVC: MySpotEditPackagePriceVCDelegate {
    func saveButtonDidClicked(price:String, editVC:MySpotEditPackagePriceVC) {
        editVC.dismiss(animated: true, completion: { [weak self] in
            print("saveButtonDidClicked :\(price)")
            self?.setPackagePrice(price: price)
        })
    }
}
