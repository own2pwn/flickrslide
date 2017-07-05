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
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var settingBtn: UIButton!
    
    /// Use two array to prepare next feed models. It's enum value whether it's current or next.
    enum ArrayPosition {
        case current
        case next
    }
    
    var photoArr: [[String:String]]!
    var nextPageArr: [[String:String]]!
    var currentIndex = 0
    
    /// Variables for setting slider timer.
    var timerIsOn: Bool = false
    var sliderTimer: Timer!
    var warmUpCount = 0
    
    /// Variables for setting count timer.
    var countTimer: Timer!
    var timerDescriptor: Int = 0
    var timerInterval: Double = 5

    /// Variables for drawing setting view.
    let alertWrapper = UIView()
    let dimBackgroundView = UIView()
    let alertView = UIView()
    let timeIntervalLabel = UILabel()
    let slidingView = UISlider()
    let alertAction1Btn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeVc()
        
        fetchData(target: ArrayPosition.current)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     // MARK: - Initialize UI controller's properties and draw alerview first.
     */
    func initializeVc() {
        
        photoView.contentMode = .scaleAspectFit
        
        timerLabel.font = UIFont(name: "SFUIText-Heavy", size: 18)
        timerLabel.textColor = UIColor.black
        
        titleLabel.font = UIFont(name: "SFUIText-Heavy", size: 22)
        titleLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        
        publishedLabel.font = UIFont(name: "SFUIText-Regular", size: 12)
        publishedLabel.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        publishedLabel.lineBreakMode = .byWordWrapping
        publishedLabel.numberOfLines = 0
        
        let titleAttributedString = NSMutableAttributedString(string: "시작" as String)
        titleAttributedString.addAttributes([NSForegroundColorAttributeName: UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1),
                                             NSFontAttributeName: UIFont(name: "SFUIText-Heavy", size: 22)!], range: NSMakeRange(0, titleAttributedString.length))
        startBtn.setAttributedTitle(titleAttributedString, for: .normal)
        
        drawAlertView()
        
    }
    
    /*
     // MARK: - Action handler for 시작 button
     */
    @IBAction func startSlideShow() {
        
        startBtn.setTitle("", for: .normal)
        startBtn.addIndicatorView(style: .gray)
        startBtn.toggleIndicatorView(willRun: true)
        
        warmUp(target: ArrayPosition.current)
        
    }
    
    /*
     // MARK: - Action handler for Setting button
     */
    @IBAction func showTimerSetting() {
        
        presentAlertView()
    }
    
    /*
     // MARK: - Fetch public feed model by Flickr API
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
     // MARK: - Manipulate model as dictionary type. change collection XML to Dictionary for convenient usage.
     */
    func manipulateModel(_ items: XMLIndexer) -> [[String:String]] {
        
        var tmpArr:[[String:String]] = [[String:String]]()
        
        for item in items["feed"]["entry"].all {
            
            for link in item["link"].all {
                
                if link.element?.attribute(by: "rel")?.text == "enclosure" {
                    
                    if let url = link.element?.attribute(by: "href")?.text {
                        
                        let model = ["title": item["title"].element?.text,
                                     "published": item["published"].element?.text,
                                     "url": url]
                        tmpArr.append(model as! [String : String])
                    }
                }
            }
        }
        
        return tmpArr
    }
    
    /*
     // MARK:- View Controller methods
     */
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }
}

