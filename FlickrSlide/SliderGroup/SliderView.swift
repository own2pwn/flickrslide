//
//  SliderSetting.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 6. 30..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit
import Kingfisher

extension ViewController {
    
    /*
     // MARK: - Download and store cache images for warm up. It's possible to show image immediately.
     */
    func warmUp(target: ArrayPosition) {
        
        // Use UIImageView for download remote image resource.
        let tmpImageView = UIImageView()
        
        let arr = target == ArrayPosition.current ? self.photoArr : self.nextPageArr
        
        if let arr = arr, arr.count > 0 {
            
            for item in arr {
                
                let url = URL(string: item["url"]!)
                if let url = url {
                    
                    tmpImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) {
                        _ in
                        
                        self.warmUpCount += 1
                        self.switchView(target: target)
                    }
                }
            }
        } else {
            
            // Try warm up again, if target array isn't prepared yet.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                
                print("try again..")
                self.warmUp(target: target)
            }
        }
    }
    
    /*
     // MARK: - Switch view if 시작 button is triggered. And this method also be called by warm up.
     */
    func switchView(target: ArrayPosition) {
        
        let arr = target == ArrayPosition.current ? self.photoArr : self.nextPageArr
        
        if let arr = arr, self.warmUpCount == arr.count {
            
            // Play slider only for starting from 시작 button
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
    
    /*
     // MARK: - Play slider, implemented by Timer.
     */
    func playSlider() {
        
        if !timerIsOn {
            
            // Initial call. Because Timer trigger method after time interval we set.
            moveNextFeed()
            // Set timer.
            activateSliderTimer()
        }
        
        timerIsOn = true
    }
    
    /*
     // MARK: - Move next feed item. If array index is positioned at 2, fetch another public feed and do warm up.
     */
    func moveNextFeed() {
        
        setModelInSliderView()
        
        if currentIndex == 2 {
            
            fetchData(target: ArrayPosition.next) { _ in
                
                self.warmUp(target: ArrayPosition.next)
            }
        }
        
        // If current array index go to end, Transit next array to current array.
        if currentIndex == photoArr.count {
            
            transitArray()
        }
    }
    
    /*
     // MARK: - set feed model in slider view. Use simple UIView animation for fade in and out.
     */
    func setModelInSliderView() {
        
        // Play count label timer for display remain time for next model.
        activateCountTimer()
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.photoView.alpha = 0
            self.titleLabel.alpha = 0
            self.publishedLabel.alpha = 0
            
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.photoView.alpha = 1
            self.titleLabel.alpha = 1
            self.publishedLabel.alpha = 1
            
            self.titleLabel.text = self.photoArr[self.currentIndex]["title"]?.nvr("untitled")
            
            let formattedDate = DateHelper.shared.convertDateFormat(self.photoArr[self.currentIndex]["published"]!,
                                                                    currentDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ",
                                                                    convertDateFormat: "yyyy년 MM월 dd일 HH시 mm분 ss초")
            self.publishedLabel.text = "Published at \(formattedDate)"
            
            let url = URL(string: self.photoArr[self.currentIndex]["url"]!)
            if let url = url {
                
                self.photoView.kf.setImage(with: url, placeholder: nil, options: nil)
            }
        })
        
        currentIndex += 1
    }
    
    /*
     // MARK: - activate slider timer.
     */
    func activateSliderTimer() {
        
        sliderTimer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(moveNextFeed), userInfo: nil, repeats: true)
    }
    
    /*
     // MARK: - activate count label timer.
     */
    func activateCountTimer() {
        
        timerDescriptor = Int(timerInterval)
        timerDescription()
        
        if let timer = countTimer, timer.isValid {
            
            timer.invalidate()
        }
        
        countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDescription), userInfo: nil, repeats: true)
    }
    
    /*
     // MARK: - set remain time to timer label.
     */
    func timerDescription() {
        
        if timerDescriptor >= 1 {
            timerLabel.text = "\(timerDescriptor)"
            timerDescriptor -= 1
        }
    }
    
    /*
     // MARK: - Transit next array to current array.
     */
    func transitArray() {
        
        // purge image cache for effective memory management.
        purgeImageCache(arr: photoArr)
        
        photoArr = nextPageArr
        nextPageArr = nil
        currentIndex = 0
        print("preloaded => current")
    }
    
    /*
     // MARK: - Purge image cache. In this time, it's implemented that only purge when transit array called.
     */
    func purgeImageCache(arr: [[String:String]]) {
        
        if arr.count > 0 {
            
            for item in arr {
                
                if let url = item["url"] {
                    
                    ImageCache.default.removeImage(forKey: url, fromDisk: false)
                }
            }
        }
        print("purged!")
    }
    
    /*
     // MARK: - update timer interval from setting view.
     */
    func updateTimerInterval() {
        
        // There are two cases which is called this method, one is before tap start button and the another.
        
        if let timer = sliderTimer, timer.isValid {
            
            timer.invalidate()
            activateSliderTimer()
        }
        
        if let timer = countTimer, timer.isValid {
            
            timer.invalidate()
            activateCountTimer()
        }
    }
}
