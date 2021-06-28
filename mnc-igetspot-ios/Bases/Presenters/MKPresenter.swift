//
//  MKPresenter.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 10/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation

class MKPresenter {
    
    init() {
        self.prepareData()
        self.prepareDelegate()
    }
    
    func prepareDelegate() {}
    
    func prepareData() {}
    
    func start() {}
    
    func detachView() {
        
    }
    
    func isAuthenticated(code: Int) -> Bool{
        if (code != 500){
            return true
        }
        
        return false
    }
}
