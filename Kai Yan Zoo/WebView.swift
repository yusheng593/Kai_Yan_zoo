//
//  WebView.swift
//  Kai Yan Zoo
//
//  Created by yusheng Lu on 2020/4/1.
//  Copyright © 2020 YushengLu. All rights reserved.
//

import UIKit
import WebKit
class WebView: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:"https://www.zoo.gov.taipei/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
    }}
