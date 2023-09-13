//
//  AlertUI.swift
//  
//
//  Created by Vishweshwaran on 11/06/22.
//

import SwiftUI
import FontKit

public enum AlertType: String {
    case error = "x.circle.fill"
    case success = "checkmark.circle.fill"
}

public struct AlertUI: View {
    
    public let title: String
    public let subtile: String?
    public let alertType: AlertType
    
    public init(title: String, subtitle: String? = nil, alertType: AlertType = .error) {
        self.title = title
        self.subtile = subtitle
        self.alertType = alertType
    }
    
    public var body: some View {
        HStack {
            Image(systemName: alertType.rawValue)
                .font(.title)
                .foregroundColor(alertType == .success ? Colors.green : Colors.red)
            alertContentView
                .padding(.all, 6)
        }
        .frame(maxWidth: 280, maxHeight: 80)
        .loaderBackground(colors: gradientColors)
    }
    
    private var alertContentView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.inter(.semibold(size: 16)))
                .foregroundColor(alertType == .success ? Colors.green : Colors.red)
                .reduceFontSize(for: 1)
            if let subtitle = subtile {
                Text(subtitle)
                    .font(.inter(.medium(size: 14)))
                    .foregroundColor(.gray)
                    .reduceFontSize(for: 2)
            }
        }
    }
    
    private var gradientColors: [Color] {
        if alertType == .success {
            return [
                Colors.gradient_green.opacity(0.9),
                Colors.gradient_green.opacity(0.5),
                Colors.gradient_green.opacity(0.7)
            ]
        } else {
            return [
                Colors.red_gradient.opacity(0.9),
                Colors.red_gradient.opacity(0.5),
                Colors.red_gradient.opacity(0.7)
            ]
        }
    }
}

struct AlertUI_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all)
                AlertUI(title: "Downloaded Successfully", subtitle: "Video saved in the photos app", alertType: .success)
            }
            .previewDevice("iPhone SE (3rd generation)")
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all)
                AlertUI(title: "This not a vaild YouTube Url", subtitle: nil, alertType: .error)
            }
            .previewDevice("iPhone SE (3rd generation)")
        }
        .preferredColorScheme(.dark)
    }
}
