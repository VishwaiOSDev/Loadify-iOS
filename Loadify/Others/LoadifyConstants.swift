//
//  LoadifyConstants.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/19/22.
//

import SwiftUI

typealias Texts = Loadify.Texts

struct Loadify {
    
    struct Texts {
        static let loading = "LOADING"
        static let downloading = "DOWNLOADING"
        static let downloadedTitle = "Downloaded Successfully"
        static let downloadedSubtitle = "Added to photos"
        static let photosAccessTitle = "Photos access is required"
        static let photosAccessSubtitle = "To enable access, go to Settings > Privacy > Photos and turn on All Photos access for this app."
        static let tryAgain: [String] = ["Please try again later", "Oops, something went wrong", "There was an error. Please try again later"]
        static let noInternet = "No Internet Connection"
        static let noInternetMessage = "Make sure your device is connected to the internet"
    }
}
