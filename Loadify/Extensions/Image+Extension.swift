//
//  Image+Extension.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/22/22.
//

import SwiftUI

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
