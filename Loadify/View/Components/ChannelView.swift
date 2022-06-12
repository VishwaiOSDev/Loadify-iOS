//
//  ChannelView.swift
//  Loadify
//
//  Created by Vishweshwaran on 02/06/22.
//

import SwiftUI

struct ChannelView: View {
    
    var name: String
    var profileImage: String
    var subscriberCount: Int?
    
    var body: some View {
        HStack {
            channelImageView
            VStack(alignment: .leading) {
                channelInfoView
            }
        }
    }
    
    private var channelImageView: some View {
        Image(systemName: "photo.circle.fill")
            .data(url: profileImage)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
    
    @ViewBuilder
    private var channelInfoView: some View {
        Text("\(name)")
            .foregroundColor(.white)
            .font(.subheadline)
            .fontWeight(.heavy)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
        subscriberCountView
            .font(.footnote)
            .foregroundColor(Loadify.Colors.grey_text)
    }
    
    @ViewBuilder
    private var subscriberCountView: some View {
        if let subscribers = subscriberCount {
            Text("\(subscribers.toUnits) subscribers")
        } else {
            Text("Subscribers hidden")
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(name: "Fx Artist", profileImage: "https://yt3.ggpht.com/wzh-BL3_M_uugIXZ_ANSSzzBbi_w5XnNSRl4F5DbLAxKdTfXkjgx-kWM1mChdrrMkADRQyB-nQ=s176-c-k-c0x00ffffff-no-rj", subscriberCount: 5000)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
