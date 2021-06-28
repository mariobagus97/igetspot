//
//  BlogCommentPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

class BlogCommentPresenter : MKPresenter {
    
    private weak var view: BlogCommentVC?
    private var blogCommentService: BlogCommentService?
    
    override init() {
        super.init()
        blogCommentService = BlogCommentService()
    }
    
    func attachview(_ view: BlogCommentVC) {
        self.view = view
    }
    
    func getlist(blogId: String){
        view?.showLoadingView()
        
        var temp1 = BlogComment()
        temp1.replyId = "1"
        temp1.commentId = "2"
        temp1.comment = "Vivamus bibendum, elit eget tincidunt consectetur, tellus mauris rhoncus est, sit amet finibus risus lacuset tellus."
        temp1.commentSubject = "Aenean vel ornare felis"
        temp1.date = "1 day ago, 3:00 PM"
        temp1.blogId = "123"
        temp1.userId = "niqnfiqbfiubeiufbeiufb"
        temp1.userName = "destanti"
        
        var tempList = [BlogComment]()
        
        tempList.append(temp1)
        tempList.append(temp1)
        
        self.view?.setContent(commentList: tempList)
//        blogCommentService?.requestCommentList(blogId: blogId, success: { [weak self] (apiResponse) in
//            self?.view?.hideLoadingView()
//            if let array = apiResponse.data.array, array.count > 0 {
//                let blog = BlogComment.with(jsons: array)
//                self?.view?.setContent(commentList: blog)
//            }
//            }, failure: { [weak self] (error) in
//                self?.view?.hideLoadingView()
////                self?.view?.showErrorView(message: error.)
//        })
    }
}

