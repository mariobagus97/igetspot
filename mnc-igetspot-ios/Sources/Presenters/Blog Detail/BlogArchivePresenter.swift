//
//  BlogArchivePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/27/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

protocol BlogArchiveView: ParentProtocol {
    func setContent(blogArray: [Whatson])
}

class BlogArchivePresenter : MKPresenter {
    
    private weak var view: BlogArchiveView?
    private var blogService: BlogService?
    
    override init() {
        super.init()
        blogService = BlogService()
    }
    
    func attachview(_ view: BlogArchiveView) {
        self.view = view
    }
    
    func getList(){
        view?.showLoading()
        blogService?.requestArchivedBlogs(success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let blogs = Whatson.with(jsons: apiResponse.data.arrayValue)
            if blogs.count == 0 {
                self?.view?.showEmpty!(NSLocalizedString("Sorry, no blog available at the moment", comment: ""), nil)
            } else {
                self?.view?.setContent(blogArray: blogs)
            }
            }, failure: { [weak self] (error) in
                self?.view?.hideLoading()
                self?.view?.showEmpty!("\(error.message)", nil)
        })
    }
}
