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
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let webUrl = URL(string: url)!
        let request = URLRequest(url: webUrl)
        uiView.load(request)
    }
}
