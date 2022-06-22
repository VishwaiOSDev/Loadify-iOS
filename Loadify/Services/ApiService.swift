//
//  ApiService.swift
//  Loadify
//
//  Created by Vishweshwaran on 5/8/22.
//

import UIKit
import Photos
import SwiftDI

protocol DataService {
    func getVideoDetails(for url: String) async throws -> VideoDetails
    func downloadVideo(for url: String, quality: VideoQuality) async throws
}

class ApiService: DataService {
    
    @Inject var photoService: PhotosServiceProtocol
    @Inject var fileSerivce: FileServiceProtocol
    
    func getVideoDetails(for url: String) async throws -> VideoDetails {
        try checkIsValidUrl(url)
        let apiUrl = Api.baseUrl + Api.YouTube.getDetails.rawValue + url
        let url = try getUrl(from: apiUrl)
        let request = createUrlRequest(for: url)
        let (data, urlResponse) = try await URLSession.shared.data(from: request)
        try await checkForServerErrors(for: urlResponse, with: data)
        return decode(data, to: VideoDetails.self)
    }
    
    func downloadVideo(for url: String, quality: VideoQuality) async throws {
        try checkIsValidUrl(url)
        let apiUrl = (
            Api.baseUrl +
            Api.YouTube.downloadVideo.rawValue +
            url +
            Api.YouTube.videoQuality.rawValue +
            quality.rawValue
        )
        let url = try getUrl(from: apiUrl)
        try await photoService.checkForPhotosPermission()
        let request = createUrlRequest(for: url)
        let filePath = fileSerivce.getTemporaryFilePath()
        let (data, urlResponse) = try await URLSession.shared.data(from: request)
        try await checkForServerErrors(for: urlResponse, with: data)
        try data.write(to: filePath)
        try checkVideoIsCompatible(at: filePath.path)
        UISaveVideoAtPathToSavedPhotosAlbum(filePath.path, nil, nil, nil)
    }
}
