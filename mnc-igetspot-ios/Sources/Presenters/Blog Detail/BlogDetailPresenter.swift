//
//  BlogDetailPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/27/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

protocol BlogDetailView: ParentProtocol {
    func setContent(blog: Whatson)
}

class BlogDetailPresenter : MKPresenter {
    
    private weak var view: BlogDetailView?
    private var blogService: BlogService?
    
    override init() {
        super.init()
        blogService = BlogService()
    }
    
    func attachview(_ view: BlogDetailView) {
        self.view = view
    }
    
    func getDetail(detailId: String){
        view?.showLoading()
        blogService?.requestBlogDetail(blogId: detailId, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let blog = Whatson.with(json: apiResponse.data)
            self?.view?.setContent(blog: blog)
            }, failure: { [weak self] (error) in
                self?.view?.showLoading()
                self?.view?.showErrorMessage?(error.message)
        })
    }
    
    func filterBlogArray(blog:Whatson, blogArray:[Whatson]?) -> [Whatson] {
        guard let blogs = blogArray, let blogId = blog.id else {
            return [Whatson]()
        }
        
        let filterArray = blogs.filter{$0.id != blogId}
        return filterArray
    }
}
