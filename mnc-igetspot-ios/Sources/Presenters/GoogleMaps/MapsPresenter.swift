//
//  MapsPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/13/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Alamofire

class MapsPresenter: MKPresenter {
    
    private weak var view: SearchLocationVC!
    var mapsStore =  MapsStore()
    
    override init() {
        super.init()
        
        mapsStore.delegate = self
    }
    
    func attachview(_ view: SearchLocationVC) {
        self.view = view
    }
    
    func searchLocation(keyword: String){
        
        self.mapsStore.call(keyword: keyword)
    }
}

extension MapsPresenter : MapsStoreDelegate {
    func mapsStoreFailed(errorCode: Int, message: String) {
        //
    }
    
    func mapsStoreSuccess(candidateList: [Candidates]) {
        self.view.setTableContent(candidateList : candidateList)
    }
    
}

