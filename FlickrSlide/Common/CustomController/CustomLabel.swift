//
//  CustomLabel.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 6. 30..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    enum FontType {
        case heavy
        case light
    }

    init(fontType: FontType, size: CGFloat) {
        super.init(frame: CGRect.zero)
        
        self.font = fontType == .heavy ?
            UIFont(name: "SFUIText-Heavy", size: size) : UIFont(name: "SFUIText-Regular", size: size)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
