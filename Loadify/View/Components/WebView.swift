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
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> WebCoordinator {
        WebCoordinator(didStart: {
            showLoading = true
        }, didFinish: {
            showLoading = false
        })
    }
}
