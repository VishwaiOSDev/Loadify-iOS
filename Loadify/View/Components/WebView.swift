//
//  WebView.swift
//  Loadify
//
//  Created by Vishweshwaran on 13/06/22.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    var url: String
    @Binding var showLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        let webUrl = URL(string: url)!
        let request = URLRequest(url: webUrl)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> WebCoordinator {
        WebCoordinator(didStart: {
            showLoading = true
        }, didFinish: {
            showLoading = false
        })
    }
}

class WebCoordinator: NSObject, WKNavigationDelegate {
    var didStart: () -> Void
    var didFinish: () -> Void
    
    init(didStart: @escaping () -> Void = {}, didFinish: @escaping () -> Void = {}) {
        self.didStart = didStart
        self.didFinish = didFinish
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        didStart()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.didFinish()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}
