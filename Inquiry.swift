//
//  Inquiry.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/18/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import Foundation
import Alamofire

class Inquiry {
    
    class Result {
        var outcome: String = "failure"
        var message: String = ""
        var status: String = ""
        var desc: String = ""
        var date: String = ""
        var reference: String = ""
        
        required convenience init(outcome: JSON) {
            self.init(outcome: outcome["outcome"].stringValue, message: outcome["message"].stringValue, status: outcome["status"].stringValue, desc: outcome["desc"].stringValue, date: outcome["date"].stringValue,
                      reference: outcome["reference"].stringValue)
        }
        
        required init(outcome: String, message: String, status: String, desc: String, date: String, reference: String) {
            self.outcome = outcome
            self.message = message
            self.status = status
            self.desc = desc
            self.date = date
            self.reference = reference
        }
    }
    
    class Response {
        var outcome: String = "failure"
        var message: String = ""
        var status: String = ""
        var desc: String = ""
        var shareAmount: String = ""
        var shareType: String = ""
        var policyHolder: String = ""
        var reference: String = ""
        var name: String = ""
        
        required convenience init(outcome: JSON) {
            self.init(outcome: outcome["outcome"].stringValue,
                      message: outcome["message"].stringValue,
                      status: outcome["status"].stringValue,
                      desc: outcome["desc"].stringValue,
                      shareAmount: (outcome["share"]["amount"]).stringValue,
                      shareType: (outcome["share"]["type"]).stringValue,
                      policyHolder: (outcome["policy"]["policyHolder"]).stringValue,
                      reference: outcome["reference"].stringValue, name: outcome["member"]["name"].stringValue)
        }
        
        required init(outcome: String, message: String, status: String, desc: String, shareAmount: String, shareType: String, policyHolder: String, reference: String, name: String) {
            self.outcome = outcome
            self.message = message
            self.status = status
            self.desc = desc
            self.shareAmount = shareAmount
            self.shareType = shareType
            self.policyHolder = policyHolder
            self.reference = reference
            self.name = name
        }
    }
    
    class MixedResponse {
        var result: Result?
        var response: Response?
        
        init(outcome: JSON) {
            self.result = Result(outcome: outcome["approval"])
            self.response = Response(outcome: outcome["eligibility"])
        }
        
    }

    
    static func doDetail(referenceNo: String, providerCode: String, payerCode: Int, completion: @escaping (Result?, NSError?)->Void) {
        let parameters: Parameters = [
            "card": [
                "payer": payerCode.description
            ]
        ]
        Alamofire.request(String.init(format:URLs.INQUIRE_DETAIL, providerCode, referenceNo), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response -> Void in
            switch response.result {
            case .success(let data) :
                let json = JSON(data)
                //print(json)
                //outcome(json: json, completionHandler: {result, error in
                    //if error == nil {
                        let result = Result(outcome: json)
                        completion(result, nil)
                    //} else {
                    //    completion(nil, error)
                    //}
                //})
            case.failure(let error):
                completion(nil, error as NSError?)
            }
        }
    }
    
    static func doSummary(cardNo: String, policyNo: String, providerCode: String, payerCode: Int, completion: @escaping (Result?, NSError?)->Void) {
        let parameters: Parameters = [
            "card": [
                "no": cardNo,
                "policy": policyNo,
                "payer": payerCode.description
            ],
            "payload": [
                "start": "2016/02/10",
                "end": "2017/02/10"
            ]
        ]
        Alamofire.request(String.init(format:URLs.INQUIRE_SUMMARY, providerCode), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response -> Void in
            switch response.result {
            case .success(let data) :
                let json = JSON(data)
                //print(json)
                //outcome(json: json, completionHandler: {result, error in
                //if error == nil {
                let result = Result(outcome: json)
                completion(result, nil)
                //} else {
                //    completion(nil, error)
                //}
            //})
            case.failure(let error):
                completion(nil, error as NSError?)
            }
        }
    }
    
    static func check(cardNo: String, policyNo: String, providerCode: String, payerCode: Int, completion: @escaping (Response?, NSError?)->Void) {
        let parameters: Parameters = [
            "card": [
                "no": cardNo,
                "policy": policyNo,
                "payer": payerCode.description
            ],
            "payload": [
                "department": "10"
            ]
        ]
        Alamofire.request(String.init(format:URLs.CARD_CHECK, providerCode), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response -> Void in
            switch response.result {
            case .success(let data) :
                let json = JSON(data)
                //print(json)
                //outcome(json: json, completionHandler: {result, error in
                //    if error == nil {
                        let response = Response(outcome: json)
                        completion(response, nil)
                    //} else {
                    //    completion(nil, error)
                    //}
                //})
            case.failure(let error):
                completion(nil, error as NSError?)
            }
            
        }
    }
    
    static func checkin(cardNo: String, policyNo: String, providerCode: String, payerCode: Int, completion: @escaping (MixedResponse?, NSError?)->Void) {
        let parameters: Parameters = [
            "card": [
                "no": cardNo,
                "policy": policyNo,
                "payer": payerCode.description
            ],
            "payload": [
                "department": "10"
            ]
        ]
        Alamofire.request(String.init(format:URLs.CHECK_IN, providerCode, "2016-02-10", "2017-02-10"), method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {response -> Void in
            switch response.result {
            case .success(let data) :
                let json = JSON(data)
                //print(json)
                //outcome(json: json, completionHandler: {result, error in
                //    if error == nil {
                let response = MixedResponse(outcome: json)
                completion(response, nil)
                //} else {
                //    completion(nil, error)
                //}
            //})
            case.failure(let error):
                completion(nil, error as NSError?)
            }
            
        }
    }

    
    static func outcome(json: JSON, completionHandler: (Any?, NSError?) -> Void) {
        /*if json["outcome"].stringValue.caseInsensitiveCompare("success") == ComparisonResult.orderedSame {
                completionHandler("success", nil)
        } else {
            completionHandler(nil, NSError(domain: "Healthcover", code: 404, userInfo: [
                NSLocalizedDescriptionKey: json["message"].stringValue]))
        }*/
        //completionHandler(json["outcome"].stringValue, )
    }


}
