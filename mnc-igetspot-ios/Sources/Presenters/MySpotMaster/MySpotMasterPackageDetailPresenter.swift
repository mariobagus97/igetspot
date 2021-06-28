////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotEditPackageDetailView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(packageDetail : MySpotPackageDetail)
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func showPackageDetailLoadingHUD(message:String?)
    func hidePackageDetailLoadingHUD()
    func showMessageSuccess(message:String)
    func showMessageError(message:String)
    func handleSuccessDelete()
    func requestPackageDetail()
    func popSelf()
}

class MySpotMasterPackageDetailPresenter: MKPresenter {
    private weak var packageDetailView: MySpotEditPackageDetailView?
    var mySpotService: MySpotMasterDetailService?
    var mySpotEditService: MySpotMasterDetailEditService?
    
    override init() {
        super.init()
        mySpotService = MySpotMasterDetailService()
        mySpotEditService = MySpotMasterDetailEditService()
    }
    
    func attachview(_ view: MySpotEditPackageDetailView) {
        self.packageDetailView = view
    }
    
    func getPackageDetail(packageId:String) {
        packageDetailView?.showLoadingView()
        mySpotService?.requestMySpotPackageDetail(packageId: packageId, success: { [weak self] (apiResponse) in
            self?.packageDetailView?.hideLoadingView()
            let packageDetail = MySpotPackageDetail.with(json: apiResponse.data)
            self?.packageDetailView?.setContent(packageDetail: packageDetail)
            }, failure: { [weak self] (error) in
                self?.packageDetailView?.hideLoadingView()
                let errorMessage = error.statusCode == 400 ? NSLocalizedString("Package details not found", comment: "") : error.message
                self?.packageDetailView?.showEmptyView(withMessage: errorMessage, description: nil,
                                                             buttonTitle: NSLocalizedString("Try Again", comment: ""),
                                                             emptyCellButtonType:.error)
        })
    }
    
    func buildParameters(description:String, packagePrice:String, imagePortofolioArray:[String: Any]) -> [String:Any] {
        var parameters = [String:Any]()
        parameters["Description"] = description
        parameters["Price"] = packagePrice
//        var imageArray = [String]()
//        for portofolioImage in imagePortofolioArray {
//            if portofolioImage.image != nil  {
//                imageArray.append(portofolioImage.image!.jpgToBase64String())
//            } else {
//                imageArray.append(portofolioImage.imageUrl!)
//            }
//        }
//        parameters["Images"] = imageArray
        
        return parameters
    }
    
    
    func editPackageDetails(packageId:String, description:String, packagePrice:String, packagePortofolioArray:[String]) {
        
        let param : [String: Any] = [
            "Description": description,
            "Price": packagePrice,
            "Images": packagePortofolioArray
        ]
        packageDetailView?.showPackageDetailLoadingHUD(message: NSLocalizedString("Saving Package..", comment: ""))
        mySpotEditService?.requestEditPackageDetails(packageId: packageId, parameters: param, success: { [weak self] (apiResponse) in
            self?.packageDetailView?.hidePackageDetailLoadingHUD()
            self?.packageDetailView?.showMessageSuccess(message: NSLocalizedString("Edit Package Success", comment: ""))
            self?.packageDetailView?.popSelf()
            }, failure: { [weak self] (error) in
                self?.packageDetailView?.hidePackageDetailLoadingHUD()
                self?.packageDetailView?.showMessageError(message: error.message)
        })
    }
    
    func deletePackageDetail(packageId:String) {
        packageDetailView?.showPackageDetailLoadingHUD(message:NSLocalizedString("Deleting..", comment: ""))
        mySpotEditService?.requestDeletePackageDetails(packageId: packageId, success: { [weak self] (apiResponse) in
            self?.packageDetailView?.hidePackageDetailLoadingHUD()
            self?.packageDetailView?.handleSuccessDelete()
            }, failure: { [weak self] (error) in
                self?.packageDetailView?.hidePackageDetailLoadingHUD()
                self?.packageDetailView?.showMessageError(message: error.message)
        })
    }
}
