//
//  DateHelper.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 7. 3..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit

class DateHelper {

    static let shared = DateHelper()
    
    private init() {
    }
    
    /*
     // MARK: 날짜 포멧 변환
     */
    func convertDateFormat(_ day: String, currentDateFormat: String, convertDateFormat: String) -> String {
        
        let formatter = DateFormatter();
        
        formatter.dateFormat = currentDateFormat
        let currentDate: Date = formatter.date(from: day)!
        
        formatter.dateFormat = convertDateFormat
        let convertedDateString: String = formatter.string(from: currentDate)
        
        return convertedDateString
    }

}
