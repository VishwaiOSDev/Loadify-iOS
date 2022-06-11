//
//  LoadifyConfig.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/19/22.
//

import SwiftUI

typealias Texts = Loadify.Texts
typealias Colors = Loadify.Colors
typealias Images = Loadify.Images

struct Loadify {
    struct Colors {
        static let app_background = Color("app_background")
        static let grey_text = Color("grey_text")
        static let textfield_background = Color("textfield_background")
        static let blue_accent = Color("blue_accent")
    }
    
    struct Images {
        static let loadify_icon = "loadify_icon"
        static let loadify_horizontal = "loadify_horizontal"
    }
    
    struct Texts {
        static let loading = "LOADING"
        static let downloading = "DOWNLOADING"
        static let photos_access_title = "Photos access is required"
        static let photos_access_subtitle = "To enable access, go to Settings > Privacy > Photos and turn on All Photos access for this app."
        static let try_again: [String] = ["Please try again later", "Oops, something went wrong", "There was an error. Please try again later"]
    }
}
