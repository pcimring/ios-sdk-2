//
//  ViewController.swift
//  Super Simple Widget App
//
//  Created by Peter Cimring on 09/06/2020.
//  Copyright © 2020 com.pcimring. All rights reserved.
//

import UIKit
import TaboolaSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        // Is this still relevant?
        // let publisherInfo = PublisherInfo.init(publisherId: "sdk-tester-demo")
        // Taboola.initWith(publisherInfo)
        
        super.viewDidLoad()
    
        // Instantiate the Widget and add it to the View...
        let myFrame = CGRect(x: (view.bounds.size.width - 200)/2, y: 140, width: 200, height: 150) // let's center our Widget
        let taboolaView = TaboolaView(frame: myFrame)
        view.addSubview(taboolaView)
        
        // Set the view properties...
                
        // The Widget Template ID
        taboolaView.mode = "alternating-widget-without-video-1x4"

        // Your Account ID
        taboolaView.publisher = "sdk-tester-demo"

        // The Page Type on which the widget will display (article, photo, video, home, categor or search) If you're not sure, contact your account manager.
        taboolaView.pageType = "article"

        // The Canonical URL for the page on which the Widget will display
        taboolaView.pageUrl = "https://blog.taboola.com"

        // Is this still relevant?
        //(Optional) Your internal ID for the page on which the Widget will display
        //taboolaView.pageId = "my-page-id"

        // The Placement ID for the Widget
        taboolaView.placement = "Below Article"

        //The Target Type of the page on which the widget is displayed. If you're not sure, contact your account manager.
        taboolaView.targetType = "mix"
        
        // Populate the Widget
        taboolaView.fetchContent()
        
    }
}

