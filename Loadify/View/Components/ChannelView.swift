//
//  ChannelView.swift
//  
//
//  Created by Vishweshwaran on 30/10/22.
//

import SwiftUI
import FontKit

public struct ChannelView: View {
    
    private var name: String
    private var profileImage: String
    private var subscriberCount: String
    
    public init(name: String, profileImage: String, subscriberCount: String) {
        self.name = name
        self.profileImage = profileImage
        self.subscriberCount = subscriberCount
    }
    
    public var body: some View {
        HStack {
            channelImageView
            VStack(alignment: .leading) {
                channelInfoView
            }
        }
    }
    
    private var channelImageView: some View {
        ImageView(urlString: profileImage) {
            createImage(image: Image(systemName: "photo.circle.fill"))
        } image: {
            createImage(image: $0)
        } onLoading: {
            ProgressView()
        }
    }
    
    private func createImage(image: Image) -> some View {
        image
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
    
    @ViewBuilder
    private var channelInfoView: some View {
        Text("\(name)")
            .foregroundColor(.white)
            .font(.inter(.bold(size: 16)))
            .lineLimit(2)
            .minimumScaleFactor(0.5)
        subscriberCountView
            .foregroundColor(LoadifyColors.greyText)
    }
    
    @ViewBuilder
    private var subscriberCountView: some View {
        Text("\(subscriberCount) subscribers")
            .font(.inter(.regular(size: 12)))
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(name: "Fx Artist", profileImage: "https://yt3.ggpht.com/wzh-BL3_M_uugIXZ_ANSSzzBbi_w5XnNSRl4F5DbLAxKdTfXkjgx-kWM1mChdrrMkADRQyB-nQ=s176-c-k-c0x00ffffff-no-rj", subscriberCount: "5000")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
