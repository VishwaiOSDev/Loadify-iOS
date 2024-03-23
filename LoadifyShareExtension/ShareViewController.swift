//
//  ShareViewController.swift
//  LoadifyShareExtension
//
//  Created by Cédric Bahirwe on 22/03/2024.
//

import UIKit
import SwiftUI
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            closeView()
            return
        }
        
        let supportedIdentifiers: [String] = [UTType.url, .plainText].map(\.identifier)
        guard let conformingTypeIdentifier = supportedIdentifiers.first(where: itemProvider.registeredTypeIdentifiers.contains) else {
            closeView()
            return
        }
        
        itemProvider.loadItem(forTypeIdentifier: conformingTypeIdentifier , options: nil) { [weak self] (providedURL, error) in
            guard let self else { return }
            if error != nil {
                self.closeView()
                return
            }
            
            if let url = providedURL as? URL ?? (providedURL as? String).flatMap({ URL(string: $0) }) {
                
                DispatchQueue.main.async {
                    let contentView = UIHostingController(rootView: ShareExtensionView(url: url))
                    self.addChild(contentView)
                    self.view.addSubview(contentView.view)
                    
                    contentView.view.translatesAutoresizingMaskIntoConstraints = false
                    contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                    contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
                    contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                    contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.closeView()
                    let deeplinkURL = self.getDeeplinkFrom(url)
                    self.openURL(url: deeplinkURL)
                }
            } else {
                self.closeView()
                return
            }
        }
    }
    
    private func getDeeplinkFrom(_ url: URL) -> URL {
         return URL(string: "loadify://?url=\(url.absoluteString)")!
    }
    
    private func closeView() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

// MARK: - Private Helpers

private extension ShareViewController {
    
    @discardableResult
    func openURL(url: URL) -> Bool {
        do {
            let application = try sharedApplication()
            application.open(url)
            
            return true
        }
        catch {
            return false
        }
    }
    
    // Working, unstable solution ATM
    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }
            
            responder = responder?.next
        }
        
        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
}
