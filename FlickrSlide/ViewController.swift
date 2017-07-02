//
//  ViewController.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 6. 29..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit
import SWXMLHash
import Kingfisher

class ViewController: UIViewController {
    
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var startBtn: CustomButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    enum ArrayPosition {
        case current
        case next
    }
    
    var photoArr: [[String:String]]!
    var nextPageArr: [[String:String]]!
    
    var timerIsOn: Bool = false
    var currentIndex = 0
    var warmUpCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(target: ArrayPosition.current)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     // MARK: - Action handler for 시작 button
     */
    @IBAction func startSlideShow() {
        
        startBtn.addIndicatorView(style: .gray)
        startBtn.toggleIndicatorView(willRun: true)
        
        warmUp(target: ArrayPosition.current)
        
    }
    
    /*
     // MARK: - fetch public feed model by Flickr API
     */
    func fetchData(target: ArrayPosition, completion: ((_ isSuccess: Bool) -> Void)? = nil) {
        
        RequestHelper.shared.requestGet("https://api.flickr.com/services/feeds/photos_public.gne") {
            isSuccess, result in
            
            if let result = result, isSuccess == true {
                
                if target == ArrayPosition.current {
                    self.photoArr = self.manipulateModel(result)
                } else {
                    self.nextPageArr = self.manipulateModel(result)
                    completion!(true)
                }
            }
        }
    }

    /*
     // MARK: - manipulate model as dictionary type
     */
    func manipulateModel(_ items: XMLIndexer) -> [[String:String]] {
        
        var tmpArr:[[String:String]] = [[String:String]]()
        
        for item in items["feed"]["entry"].all {
            
            for link in item["link"].all {
                
                if link.element?.attribute(by: "rel")?.text == "enclosure" {
                    
                    if let url = link.element?.attribute(by: "href")?.text {
                        
                        let model = ["title": item["title"].element?.text,
                                     "url": url]
                        tmpArr.append(model as! [String : String])
                    }
                }
            }
        }
        
        return tmpArr
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        titleLabel.setNeedsUpdateConstraints()
        photoView.setNeedsUpdateConstraints()
    }
}

