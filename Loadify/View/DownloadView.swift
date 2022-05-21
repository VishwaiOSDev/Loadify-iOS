//
//  DownloadView.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/9/22.
//

import SwiftUI

struct DownloadView: View {
    
    var videoDetails: VideoDetails?
    
    var body: some View {
        ZStack {
            Loadify.Colors.app_background
                .edgesIgnoringSafeArea(.all)
            checkDetailsExists()
                .padding()
        }
    }
    
    @ViewBuilder
    private func checkDetailsExists() -> some View {
        if let videoDetails = videoDetails {
            constructBody(with: videoDetails)
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder
    private func constructBody(with details: VideoDetails) -> some View {
        VStack {
            Image(Loadify.Images.loadify_horizontal)
            Spacer()
            VStack {
                VStack {
                    Image(systemName: "person.fill")
                        .data(url: details.thumbnails[details.thumbnails.count - 1].url)
                        .scaledToFit()
                        .clipped()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(details.title)")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .lineLimit(2)
                        HStack {
                            Image(systemName: "person.fill")
                                .data(url: details.author.thumbnails[details.author.thumbnails.count - 1].url)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text("\(details.ownerChannelName)")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                Text("\(String(describing: details.author.subscriberCount ?? 0)) Crore subscribers")
                                    .font(.footnote)
                                    .foregroundColor(Loadify.Colors.grey_text)
                            }
                        }
                        .padding(.horizontal, 4)
                        HStack {
                            InfoView(title: details.likes.shortStringRepresentation, subTitle: "Likes")
                            Spacer()
                            InfoView(title: details.viewCount.commaFormater(), subTitle: "Views")
                            Spacer()
                            InfoView(title: "2 Apr", subTitle: "2022")
                        }
                        .padding()
                    }
                }
            }
            .background(Loadify.Colors.textfield_background)
            .cornerRadius(10)
            Spacer()
            madeWithSwift
        }
    }
    
    private var madeWithSwift: some View {
        Text("Made with 💙 using Swift")
            .font(.footnote)
            .foregroundColor(Loadify.Colors.grey_text)
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView(videoDetails: mockData)
    }
}

struct InfoView: View {
    
    var title: String
    var subTitle: String
    
    var body: some View {
        VStack {
            Text("\(title)")
                .font(.title2)
                .bold()
            Text("\(subTitle)")
                .font(.footnote)
                .foregroundColor(Loadify.Colors.grey_text)
        }
        .foregroundColor(.white)
    }
}

extension Image {
    func data(url: String) -> Self {
        guard let url = URL(string: url) else { return self.resizable() }
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self.resizable()
    }
}

extension String {
    func commaFormater() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let number = Int(self) else { return "Hidden" }
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) else { return "Hidden" }
        return formattedNumber
    }
}

extension Int {
    var shortStringRepresentation: String {
        let number = Double(self)
        if number.isNaN {
            return "NaN"
        }
        if number.isInfinite {
            return "\(number < 0.0 ? "-" : "+")Infinity"
        }
        let units = ["", "k", "M"]
        var interval = number
        var i = 0
        while i < units.count - 1 {
            if abs(interval) < 1000.0 {
                break
            }
            i += 1
            interval /= 1000.0
        }
        // + 2 to have one digit after the comma, + 1 to not have any.
        // Remove the * and the number of digits argument to display all the digits after the comma.
        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 2, interval))\(units[i])"
    }
}

let mockData = VideoDetails(title: "AVATAR 2 THE WAY OF WATER Trailer (4K ULTRA HD) 2022", description: "", lengthSeconds: "109", viewCount: "7123860", publishDate: "2022-05-09", ownerChannelName: "TrailerSpot", videoId: "", author: .init(id: "", name: "", user: "", channelUrl: "", thumbnails: [.init(url: "https://yt3.ggpht.com/wzh-BL3_M_uugIXZ_ANSSzzBbi_w5XnNSRl4F5DbLAxKdTfXkjgx-kWM1mChdrrMkADRQyB-nQ=s176-c-k-c0x00ffffff-no-rj", width: 120, height: 12)], subscriberCount: nil), likes: 57095, thumbnails: [.init(url: "https://i.ytimg.com/vi/CYYtLXfquy0/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&;amp;rs=AOn4CLCo3jfFz7jTmuiffAP7oetxwNgEbA", width: 12, height: 12)])
