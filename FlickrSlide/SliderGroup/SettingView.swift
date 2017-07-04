//
//  SettingView.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 7. 3..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit

extension ViewController {
    
    func drawAlertView() {
        
        alertWrapper.alpha = 0
        self.view.addSubview(alertWrapper)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlertView))
        tapGesture.numberOfTapsRequired = 1

        dimBackgroundView.addGestureRecognizer(tapGesture)
        dimBackgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        alertWrapper.addSubview(dimBackgroundView)
        
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 5
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 0.5
        alertView.layer.shadowOffset = CGSize.zero
        alertView.layer.shadowRadius = 10
        alertWrapper.addSubview(alertView)
        
        let titleAttributedString = NSMutableAttributedString(string: "설정" as String)
        titleAttributedString.addAttributes([NSForegroundColorAttributeName: UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1),
                                             NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 18)!], range: NSMakeRange(0, titleAttributedString.length))
        alertAction1Btn.setAttributedTitle(titleAttributedString, for: .normal)
        alertAction1Btn.addTarget(self, action: #selector(applyTimerInterval), for: .touchUpInside)
        alertView.addSubview(alertAction1Btn)
        
        timeIntervalLabel.text = "\(Int(timerInterval))초"
        timeIntervalLabel.font = UIFont(name: "SFUIText-Regular", size: 18)
        timeIntervalLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        timeIntervalLabel.textAlignment = .center
        alertView.addSubview(timeIntervalLabel)
        
        slidingView.minimumValue = 1
        slidingView.maximumValue = 10
        slidingView.value = Float(timerInterval)
        slidingView.isContinuous = true
        slidingView.tintColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        slidingView.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        alertView.addSubview(slidingView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        alertWrapper.translatesAutoresizingMaskIntoConstraints = false
        
        alertWrapper.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        alertWrapper.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        alertWrapper.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        alertWrapper.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        dimBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        dimBackgroundView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        dimBackgroundView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        dimBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        dimBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.widthAnchor.constraint(equalToConstant: 260).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        alertView.centerXAnchor.constraint(equalTo: alertWrapper.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: alertWrapper.centerYAnchor).isActive = true
        
        slidingView.translatesAutoresizingMaskIntoConstraints = false
        
        slidingView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 15).isActive = true
        slidingView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -15).isActive = true
        slidingView.centerYAnchor.constraint(equalTo: alertView.centerYAnchor).isActive = true
        slidingView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        
        timeIntervalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeIntervalLabel.leadingAnchor.constraint(equalTo: slidingView.leadingAnchor).isActive = true
        timeIntervalLabel.trailingAnchor.constraint(equalTo: slidingView.trailingAnchor).isActive = true
        timeIntervalLabel.bottomAnchor.constraint(equalTo: slidingView.topAnchor, constant: -14).isActive = true
        
        alertAction1Btn.translatesAutoresizingMaskIntoConstraints = false
        
        alertAction1Btn.leadingAnchor.constraint(equalTo: slidingView.leadingAnchor).isActive = true
        alertAction1Btn.trailingAnchor.constraint(equalTo: slidingView.trailingAnchor).isActive = true
        alertAction1Btn.topAnchor.constraint(equalTo: slidingView.bottomAnchor, constant: 12).isActive = true
        
        alertWrapper.setNeedsUpdateConstraints()
    }
    
    func dismissAlertView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alertWrapper.alpha = 0
        })
    }
    
    func presentAlertView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alertWrapper.alpha = 1
        })
    }
    
    func sliderValueDidChange(sender: UISlider) {
        
        timeIntervalLabel.text = "\(Int(sender.value))초"
    }
    
    func applyTimerInterval() {
        
        timerInterval = Double(Int(slidingView.value))
        dismissAlertView()
        
        updateTimerInterval()
    }

}
