//
//  StringExtension.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 7. 3..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit

public extension String {
    
    /*
     // MARK: - nvr function. replace the string you want if the string is empty or filled with whitespaces.
     */
    func nvr(_ replace: String = "") -> String {
        
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        
        if trimmedString == "" {
            return replace
        }
        
        return self
    }
}
