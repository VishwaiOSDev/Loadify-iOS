//
//  LoadifyConstants.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/19/22.
//

import SwiftUI

typealias Device = Loadify.Device
typealias LoadifyTexts = Loadify.Texts
typealias LoadifyColors = LoadifyKit.ColorKit
typealias LoadifyAssets = LoadifyKit.AssetKit

struct Loadify {
    
    
    static let maxWidth: CGFloat = switch UIDevice.current.userInterfaceIdiom {
    case .phone:
            .infinity
    case .pad:
        500
    default:
        600
    }
    
    struct Device {
        static let iPad = UIDevice.current.userInterfaceIdiom == .pad
        static let isLandscape: Bool = UIDevice.current.orientation.isLandscape
    }
    
    struct Texts {
        static let loading = "LOADING"
        static let downloadedTitle = "Downloaded Successfully"
        
        static let loadifySubTitle = "Download Instagram Reels, Posts, Stories and TikTok Video with Ease!"
        
        static let photosAccessTitle = "Photos access is required"
        static let photosAccessSubtitle = "To enable access, go to Settings > Privacy > Photos and turn on All Photos access for this app."
        
        static let tryAgain: [String] = ["Please try again later", "Oops, something went wrong", "There was an error. Please try again later"]
        
        static let noInternet = "No Internet Connection"
        static let noInternetMessage = "Make sure your device is connected to the internet"
        
        static let shareExtensionTitle = "Success!"
        static let shareExtensionSubtitle = "The link was successfully transferred to Loadify"
    }
    
    struct RegEx {
        static let url = #"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$"#
        static let instagram = #"https?:\/\/(?:www\.)?instagram\.com\/(?:p\/([^\/?#&]+)|reel\/([^\/?#&]+)|stories\/([^\/?#&]+)\/([^\/?#&]+)).*"#
    }
}

struct LoadifyKit {
    
    struct AssetKit {
        static let loadifyHorizontal = Image(.loadifyHorizontal)
        static let loadifyIcon = Image(.loadifyIcon)
        static let notFound = Image(.notFound)
        static let instagram = Image(.instagram)
        static let tiktok = Image(.tikTok)
        static let twitter = Image(.twitter)
    }
    
    struct ColorKit {
        static let appBackground = Color(.appBackground)
        static let greyText = Color(.greyText)
        static let textfieldBackground = Color(.textfieldBackground)
        static let blueAccent = Color(.blueAccent)
        static let errorRedGradient = Color(.errorRedGradient)
        static let errorRed = Color(.errorRed)
        static let successGreenGradient = Color(.successGreenGradient)
        static let successGreen = Color(.successGreen)
    }
}

struct Constants {
    
    static let iMacURL =  "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/imac-refurb-about-201810?wid=984&hei=859&fmt=jpeg&qlt=90&.v=1541530952135"
}
