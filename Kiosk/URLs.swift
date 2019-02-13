//
//  URLs.swift
//  Kiosk
//
//  Created by Waseel ASP Ltd. on 4/18/17.
//  Copyright © 2017 Waseel ASP Ltd. All rights reserved.
//

import Foundation

class URLs {
    //static let PROVIDERS = "https://mobility.waseel.com:28443/healthcover/api"
    static let PROVIDERS = "http://172.26.2.222:8080/healthcover/api"
    //static let TEXT_SEARCH = "http://172.26.2.248:8080/healthcover/api/textsearch"
    static let TEXT_SEARCH = "https://mobility.waseel.com:28443/healthcover/api/textsearch"
    static let NEARBY_SEARCH = "https://mobility.waseel.com:28443/healthcover/api/nearbysearch"
    //static let CARD_CHECK = "https://mobility.waseel.com:28443/healthcover/api/104/check"
    static let CARD_CHECK = "http://172.26.2.222:8080/healthcover/api/%@/check"
    static let INQUIRE_DETAIL = "http://172.26.2.222:8080/healthcover/api/%@/%@/inquire"
    static let INQUIRE_SUMMARY = "http://172.26.2.222:8080/healthcover/api/%@/inquire"
    static let CHECK_IN = "https://mobility.waseel.com:28443/healthcover/api/%@/%@/%@/checkin"
    
    // not used //
    static let PAYERS = "https://mobility.waseel.com:28443/healthcover/api/payers"
    private static let IMAGES = "https://mobility.waseel.com:28443/healthcover/images"
    static let NOTICE = "https://mobility.waseel.com:28443/healthcover/legal/notices/healthcover_en.htm"
    static let WEB = "http://www.waseel.com/"

    
    static func payerImageURL(id: String)-> String {
        return "\(URLs.IMAGES)/payers/\(id).jpg"
    }
}
