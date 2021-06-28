////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class TransactionService: IGSService {
    
    func requestTransactionWaitingList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "order/list/wait", success: success, failure: failure)
    }
    
    func requestTransactionActiveList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "order/list/active", success: success, failure: failure)
    }
    
    func requestTransactionStatus(orderId:String, packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let parameters = ["orderID":orderId,
                          "packageID":packageId]
        
        print("parameters :\(parameters)")
        
        self.request(httppMethod: .get, pathUrl: "order/status", parameters: parameters, success: success, failure: failure)
    }
    
    func requestDeletePackageWaitingTransaction(orderId:String, packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let parameters = ["order_id":orderId,
                          "package_id":packageId]
                
//        self.request(httppMethod: .delete, pathUrl: "order/delete", parameters: parameters, success: success, failure: failure )
        self.uploadMultipart(httppMethod: .delete, pathURL: "order/delete", parameters: parameters, success: success, failure: failure)
        
    }
    
    func requestTransactionDetail(transactionId:String, packageId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let parameters = ["orderID":transactionId,
                          "packageID":packageId]
        
        self.request(httppMethod: .get, pathUrl: "transactions/detail", parameters: parameters, success: success, failure: failure)
    }
    
    func requestBankList(success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "payment/bank/list", success: success, failure: failure)
    }
    
    func registrationVA(order_id:String, invoice_id:String?, paymentMethod:String, bankCode: String , success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        var parameters = ["order_id":order_id,
                          "payment_method":paymentMethod,
                          "bank_code":bankCode]
        
        if invoice_id != nil {
            parameters["invoice_id"] = invoice_id
        }
        
        print("parameters: \(parameters)")
        
        self.request(httppMethod: .post, pathUrl: "NICEPay/payment/registration", parameters: parameters, success: success, failure: failure)
    }
    
    func getVANumber(txId:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        self.request(httppMethod: .get, pathUrl: "NICEPay/payment/info/"+txId, success: success, failure: failure)
    }
    
    func requestPostRating(masterId:String, orderId:String, packageId:String, serviceQuality:Int, timelinessRating:Int, qualityRating:Int, comment:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let parameters = ["order_id":orderId,
                          "package_id":packageId,
                          "service_quality_rate":"\(serviceQuality)",
                          "timeliness_rate":"\(timelinessRating)",
                          "quality_rate":"\(qualityRating)",
                          "review": comment,
                          ]
        self.request(httppMethod: .post, pathUrl: "order/review", parameters: parameters, success: success, failure: failure)
    }
    
    func requestReportOrder(orderId:String, reason:String, reasonDescription:String, success: @escaping (_ apiResponse:MKAPIResponse)->(), failure: @escaping (ErrorAPI)->()){
        
        let parameters = ["order_id":orderId,
                          "reason":reason,
                          "reason_description": reasonDescription,
                          ]
        self.request(httppMethod: .post, pathUrl: "order/report", parameters: parameters, success: success, failure: failure)
    }
}
