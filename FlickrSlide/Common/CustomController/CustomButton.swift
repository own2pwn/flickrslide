//
//  CustomButton.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 6. 30..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var activityView: UIActivityIndicatorView?
    var tmpAttributedTitle: NSAttributedString?
    
    /*
     // MARK: - Add UIActivityIndicator inside of UIButton.
     */
    func addIndicatorView(style: UIActivityIndicatorViewStyle) {
        if activityView == nil {
            activityView = UIActivityIndicatorView(activityIndicatorStyle: style)
            activityView!.center = CGPoint(x: self.frame.width/2.0,y: self.frame.height/2.0)
            self.addSubview(activityView!)
        }
    }
    
    /*
     // MARK: - Toggle UIActivityIndicator.
     */
    func toggleIndicatorView(willRun: Bool) {
        if willRun {
            if let ai = activityView {
                ai.startAnimating()
                print(ai.center)
                tmpAttributedTitle = self.currentAttributedTitle
                self.setAttributedTitle(nil, for: .normal)
            }
        } else {
            if let ai = activityView {
                ai.stopAnimating()
                self.setAttributedTitle(tmpAttributedTitle, for: .normal)
            }
        }
    }
    
    /*
     // MARK: - Check the state it's running or not.
     */
    func isRunning() -> Bool {
        if let ai = activityView {
            return ai.isAnimating
        }
        return false
    }
    
}
