//
//  LoadifyConfig.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/19/22.
//

import SwiftUI

typealias Texts = Loadify.Texts
typealias Images = Loadify.Images

struct Loadify {
    
    struct Images {
        static let loadify_icon = "loadify_icon"
        static let loadify_horizontal = "loadify_horizontal"
    }
    
    struct Texts {
        static let loading = "LOADING"
        static let downloading = "DOWNLOADING"
        static let downloaded_title = "Downloaded Successfully"
        static let downloaded_subtitle = "Added to photos"
        static let photos_access_title = "Photos access is required"
        static let photos_access_subtitle = "To enable access, go to Settings > Privacy > Photos and turn on All Photos access for this app."
        static let try_again: [String] = ["Please try again later", "Oops, something went wrong", "There was an error. Please try again later"]
        static let no_internet = "No Internet Connection"
        static let no_internet_message = "Make sure your device is connected to the internet"
    }
}
