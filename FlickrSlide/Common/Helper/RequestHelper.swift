//
//  RequestHelper.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 6. 29..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class RequestHelper {
    
    static let shared = RequestHelper()
    
    private init() {
    }
    
    /*
     // MARK: - Request api by GET way.
     */
    func requestGet(_ requestUrl : String, completion: @escaping (_ isSuccess: Bool, _ result: XMLIndexer?) -> Void) {
        
        print(requestUrl)
        
        Alamofire.request("\(requestUrl)", method: .get, parameters: nil).response {
            response in
            
            if response.response?.statusCode == 200 {
                
                if let data = response.data {
                    let xml = SWXMLHash.parse(data)
                    completion(true, xml)
                } else {
                    completion(false, nil)
                }
            } else {
                print("something wrong with call \(requestUrl)")
                if let data = response.data {
                    let xml = SWXMLHash.parse(data)
                    completion(false, xml)
                } else {
                    completion(false, nil)
                }
            }
        }
        
    }
}
