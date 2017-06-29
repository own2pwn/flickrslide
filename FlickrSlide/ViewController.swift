//
//  ViewController.swift
//  FlickrSlide
//
//  Created by Kilro on 2017. 6. 29..
//  Copyright © 2017년 Kilro. All rights reserved.
//

import UIKit
import SWXMLHash

class ViewController: UIViewController {
    
    @IBOutlet weak var initialView: UIView!
    @IBOutlet weak var sliderView: UIView!
    
    var photoArr: [[String:String]]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     // MARK: - Action handler for 시작 button
     */
    @IBAction func startSlideShow() {
        print("hehe")
    }
    
    /*
     // MARK: - fetch public feed model by Flickr API
     */
    func fetchData() {
        
        RequestHelper.shared.requestGet("https://api.flickr.com/services/feeds/photos_public.gne") {
            isSuccess, result in
            
            if let result = result {
                
                self.photoArr = self.manipulateModel(result)
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
}

