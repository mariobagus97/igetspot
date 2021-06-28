//
//  HomePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol HomeView: class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView()
    func setContentWhatsOn(whatsonList: [Whatson])
    func setContentFeaturedServices(featuredServices:FeaturedServices)
    func setContentMasterOfTheWeeks(masters: [MasterPreview])
    func setContentSpecialDeals(deals:[Deals])
}


class HomePresenter: MKPresenter {
    private weak var view: HomeView?
    private var servicesService: ServicesService?
    private var blogService: BlogService?
    private var masterService: MasterService?
    private var specialDealsService: SpecialDealsService?
    
    override init() {
        super.init()
        servicesService = ServicesService()
        blogService = BlogService()
        masterService = MasterService()
        specialDealsService = SpecialDealsService()
    }
    
    func attachview(_ view: HomeView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func getWhatsOnList(){
        blogService?.requestBlogList(limit: 5, success: { [weak self] (apiResponse) in
            guard let jsonResponse = apiResponse.data.array else {
                self?.view?.showEmptyView()
                return
            }
            let whatsonArray = Whatson.with(jsons: jsonResponse)
            self?.view?.setContentWhatsOn(whatsonList: whatsonArray)
            }, failure: { [weak self](error) in
                self?.view?.showEmptyView()
        })
    }
    
    func getFeaturedServices() {
        view?.showLoadingView()
        servicesService?.requestFeaturedServicesCategory(success: { [weak self] (apiResponse) in
            let featuredServices = FeaturedServices.with(json: apiResponse.data)
            self?.view?.setContentFeaturedServices(featuredServices: featuredServices)
            }, failure: { (error) in
        })
    }
    
    func getMasterOfTheWeek() {
        masterService?.requestAllMasterOfTheWeek(success: { [weak self] (apiResponse) in
            let masterArray = MasterPreview.with(jsons: apiResponse.data.arrayValue)
            self?.view?.setContentMasterOfTheWeeks(masters: masterArray)
            }, failure: { (error) in
                
        })
    }
    
    func getSpecialDeals(){
        specialDealsService?.requestSpecialDeals(success: { [weak self] (apiResponse) in
            let deals = Deals.with(jsons: apiResponse.data.arrayValue)
            self?.view?.setContentSpecialDeals(deals: deals)
            }, failure: { (error) in
                
        })
    }
}
