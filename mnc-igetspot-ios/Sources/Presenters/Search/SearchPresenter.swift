//
//  SearchPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol SearchPresenterView: ParentProtocol {
    func setSearchResult(resultList: [MasterSearch])
}

class SearchPresenter: MKPresenter {
    private weak var view: SearchPresenterView?
    private var tokenService: TokenService?
    private var searchService : SearchService?
    
    override init() {
        super.init()
        tokenService = TokenService()
        searchService = SearchService()
    }
    
    func attachview(_ view: SearchPresenterView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func search(keyword : String) {
        
        self.view?.showLoading()
        searchService?.requestSearch(keyword: keyword, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let data = MasterSearch.with(jsons: apiResponse.data.arrayValue)
            self?.view?.setSearchResult(resultList: data)
            }, failure: { [weak self] (error) in
                self?.view?.showEmpty?(NSLocalizedString("No package available for \"\(keyword)\"", comment: ""), nil)
            })
        
        var testResult = [Package]()
    }
    
    func searchInMaster(masterId:String, keyword : String) {
        self.view?.showLoading()
        searchService?.searchPackageInMaster(masterId: masterId, package: keyword, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let res = MasterPackage.with(json: apiResponse.data)
            var datas = [JSON]()
            
       
            for item : PackageList in res.packages! {
                for detail: PackageDetailList in item.packageDetailList! {
                    var v  = JSON()
                    v[MasterSearch.KEY_MASTER_ID].string = res.masterID!
                    v[MasterSearch.KEY_MASTER_NAME].string = res.masterName!
                    v[MasterSearch.KEY_MASTER_AVG_RATING].intValue = detail.packageRating!
                    v[MasterSearch.KEY_MASTER_TOTAL_REVIEW].intValue = detail.packageRating!
                    v[MasterSearch.KEY_PACKAGE_ID].string = detail.packageId!
                    v[MasterSearch.KEY_PACKAGE_NAME].string = detail.packageName!
                    v[MasterSearch.KEY_PACKAGE_PRICE].string = detail.price!
                    v[MasterSearch.KEY_PACKAGE_IMAGE_URL].arrayObject = detail.imageUrls!

                    datas.append(v)
                }
            }
            
            
            
            let data = MasterSearch.with(jsons: datas)
            self?.view?.setSearchResult(resultList: data)
            }, failure: { [weak self] (error) in
                self?.view?.showEmpty?(NSLocalizedString("No package available for \"\(keyword)\"", comment: ""), nil)
        })
        
//        var testResult = [Package]()
    }
}

