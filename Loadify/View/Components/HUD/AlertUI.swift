//
//  AlertUI.swift
//  
//
//  Created by Vishweshwaran on 11/06/22.
//

import SwiftUI
import FontKit

enum AlertType: String {
    case error = "x.circle.fill"
    case success = "checkmark.circle.fill"
}

struct AlertUI: View {
    
    let title: String
    let subtile: String?
    let alertType: AlertType
    
    init(title: String, subtitle: String? = nil, alertType: AlertType = .error) {
        self.title = title
        self.subtile = subtitle
        self.alertType = alertType
    }
    
    var body: some View {
        HStack {
            Image(systemName: alertType.rawValue)
                .font(.title)
                .foregroundColor(
                    alertType == .success ? LoadifyColors.successGreen : LoadifyColors.errorRed
                )
            
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
                .foregroundColor(
                    alertType == .success ? LoadifyColors.successGreen : LoadifyColors.errorRed
                )
                .reduceFontSize(for: 1)
            
            if let subtitle = subtile {
                Text(subtitle)
                    .font(.inter(.medium(size: 14)))
                    .foregroundColor(.white)
                    .reduceFontSize(for: 2)
            }
        }
    }
    
    private var gradientColors: [Color] {
        if alertType == .success {
            return [
                LoadifyColors.successGreenGradient.opacity(0.9),
                LoadifyColors.successGreenGradient.opacity(0.5),
                LoadifyColors.successGreenGradient.opacity(0.7)
            ]
        } else {
            return [
                LoadifyColors.errorRedGradient.opacity(0.9),
                LoadifyColors.errorRedGradient.opacity(0.5),
                LoadifyColors.errorRedGradient.opacity(0.7)
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
