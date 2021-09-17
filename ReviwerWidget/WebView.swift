//
//  WebView.swift
//  ReviwerWidget
//
//  Created by Johannes Engler on 17.09.21.
//

import SwiftUI
import WebKit

struct ReviewrWebView: UIViewControllerRepresentable {
    let url: URL
    let width: CGFloat
    @ObservedObject var renderedHeight: RenderedHeight


    func makeUIViewController(context: Context) -> WebviewController {
        let webviewController = WebviewController()
        webviewController.width = width
        webviewController.renderedHeight = renderedHeight

        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webview.load(request)
        return webviewController
    }

    func updateUIViewController(_ webviewController: WebviewController, context: Context) {
        webviewController.view.frame.size.width = width
        webviewController.webview.frame = webviewController.view.frame
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webviewController.webview.load(request)
    }
}

class WebviewController: UIViewController {
    lazy var webview: WKWebView = WKWebView()
    lazy var width: CGFloat = 0
    var renderedHeight: RenderedHeight = RenderedHeight()
    var widHeight = CGFloat(0)
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if self.webview.estimatedProgress >= 1.0 {
                self.webview.evaluateJavaScript("document.getElementById('__next').scrollHeight", completionHandler: { (height, error) in
                    let flHeight = height as! CGFloat
                    if self.widHeight != flHeight {
                        self.widHeight = flHeight
                        self.view.frame.size.height = flHeight
                        self.view.frame.size.width = CGFloat(self.width)
                        self.webview.frame = self.view.frame
                        self.renderedHeight.height = flHeight
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size.width = CGFloat(self.width)
        self.webview.frame = self.view.frame
        self.view.addSubview(self.webview)
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webview.scrollView.isScrollEnabled = false
    }
    
    
}

