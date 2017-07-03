//
//  SliderSetting.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 6. 30..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit

extension ViewController {
    
    func warmUp(target: ArrayPosition) {
        
        let tmpImageView = UIImageView()
        
        let arr = target == ArrayPosition.current ? self.photoArr : self.nextPageArr
        
        for item in arr! {
            
            let url = URL(string: item["url"]!)
            if let url = url {
                
                tmpImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) {
                    image, error, cacheType, imageURL in
                    
                    self.warmUpCount += 1
                    self.switchView(target: target)
                }
            }
        }
    }
    
    func switchView(target: ArrayPosition) {
        
        let arr = target == ArrayPosition.current ? self.photoArr : self.nextPageArr
        
        if self.warmUpCount == arr?.count {
            
            if target == ArrayPosition.current {
                
                if startBtn.isRunning() == true {
                    startBtn.toggleIndicatorView(willRun: false)
                }
                
                startBtn.isHidden = true
                
                playSlider()
            }
            
            self.warmUpCount = 0
            print("Warm up completed")
        }
    }
    
    func playSlider() {
        
        if !timerIsOn {
            
            titleLabel.text = photoArr[currentIndex]["title"]
            setModelInSliderView()
            
            Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(moveNextFeed), userInfo: nil, repeats: true)
        }
        
        timerIsOn = true
    }
    
    func moveNextFeed() {
        
        setModelInSliderView()
        
        if currentIndex == 2 {
            
            fetchData(target: ArrayPosition.next) { _ in
                self.warmUp(target: ArrayPosition.next)
            }
        }
        
        if currentIndex == photoArr.count {
            transitArray()
        }
    }
    
    func setModelInSliderView() {
        
        timerDescriptor = Int(timerInterval)
        timerDescription()
        if let timer = sliderTimer, timer.isValid {
            timer.invalidate()
        }
        sliderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDescription), userInfo: nil, repeats: true)
        
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.photoView.alpha = 0
            self.titleLabel.alpha = 0
            self.publishedLabel.alpha = 0
        }) {
            _ in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                let url = URL(string: self.photoArr[self.currentIndex]["url"]!)
                if let url = url {
                    
                    self.photoView.kf.setImage(with: url, placeholder: nil, options: nil)
                }
                
                self.titleLabel.text = self.photoArr[self.currentIndex]["title"]?.nvr("untitled")
                
                let formattedDate = DateHelper.shared.convertDateFormat(self.photoArr[self.currentIndex]["published"]!,
                                                    currentDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ",
                                                    convertDateFormat: "yyyy년 MM월 dd일 HH시 mm분 ss초")
                self.publishedLabel.text = "Published at \(formattedDate)"
                
                self.photoView.alpha = 1
                self.titleLabel.alpha = 1
                self.publishedLabel.alpha = 1
            })
        }
        
        currentIndex += 1
    }
    
    func timerDescription() {
        
        if timerDescriptor >= 1 {
            timerLabel.text = "\(timerDescriptor)"
            timerDescriptor -= 1
        }
    }
    
    func transitArray() {
        
        photoArr = nextPageArr
        nextPageArr = nil
        currentIndex = 0
        print("swap! preloaded => current")
    }
    
    func showTimerIntervalSetting() {

        presentAlertView()
    }
    
}
