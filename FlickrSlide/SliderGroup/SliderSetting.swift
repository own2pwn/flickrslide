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
                
                setSliderView()
                playSlider()
            }
            
            self.warmUpCount = 0
            print("Warm up completed")
        }
    }
    
    func setSliderView() {
        
        titleLabel.text = photoArr[currentIndex]["title"]
        
        setModelInSliderView()
    }
    
    func playSlider() {
        
        if !timerIsOn {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(moveNextFeed), userInfo: nil, repeats: true)
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
            swapArray()
        }
    }
    
    func setModelInSliderView() {
        
        photoView.contentMode = .scaleAspectFit
        
        let url = URL(string: photoArr[currentIndex]["url"]!)
        if let url = url {
            
            photoView.kf.setImage(with: url, placeholder: nil, options: nil)
        }
        
        titleLabel.text = photoArr[currentIndex]["title"]
        
        currentIndex += 1
    }
    
    func swapArray() {
        
        photoArr = nextPageArr
        nextPageArr = nil
        currentIndex = 0
        print("swap!")
    }
    
}
