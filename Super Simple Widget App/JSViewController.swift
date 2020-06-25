//
//  JSViewController.swift
//  Super Simple Widget App
//
//  Created by Peter Cimring on 18/06/2020.
//  Copyright © 2020 com.pcimring. All rights reserved.
//

import UIKit
import TaboolaSDK

class JSViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        print("Loading the view for JSViewController...")
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("JSViewController loaded its view.")
        // TODO - wtite an overview of what is needed for hybrid
        
//        // TODO - Do we need the following code?
//        let config = WKWebViewConfiguration()
//        config.allowsInlineMediaPlayback = true
//        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        // TODO - document this more clearly
        // implement the `with: self` to get events (optional - see step 3)
        TaboolaJS.sharedInstance()?.registerWebView(webView, with: self as? TaboolaJSDelegate)
        TaboolaJS.sharedInstance()?.logLevel = .debug
        try? loadExamplePage()
        
        
//        // Web View - sample code
//        let url = URL(string: "https://www.hackingwithswift.com")!
//        webView.load(URLRequest(url: url))
//        webView.allowsBackForwardNavigationGestures = true
    }
    
    // TODO - Is all of this Acrobatics in order to use a local page?
    func loadExamplePage() throws {
        guard let htmlPath = Bundle.main.path(forResource: "sampleContentPage", ofType: "html") else {
            print("Error loading HTML")
            return
        }
        let appHtml = try String.init(contentsOfFile: htmlPath, encoding: .utf8)
        webView.loadHTMLString(appHtml, baseURL: URL(string: "https://cdn.taboola.com/mobile-sdk/init/"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TaboolaJS.sharedInstance()?.unregisterWebView(webView, completion: nil)
    }
    
}
