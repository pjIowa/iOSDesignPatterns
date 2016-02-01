//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by Prajwal Kedilaya on 1/31/16.
//  Copyright © 2016 Raywenderlich. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    static let sharedInstance = LibraryAPI()
    private let persistencyManager = PersistencyManager()
    private let httpClient = HTTPClient()
    private let isOnline = false
    
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"downloadImage:", name: "BLDownloadImageNotification", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbum(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
    func downloadImage(notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String: AnyObject],
            let coverUrl = userInfo["coverUrl"] as? NSString,
            let imageViewUnWrapped = userInfo["imageView"] as? UIImageView {
                
                imageViewUnWrapped.image = persistencyManager.getImage(coverUrl.lastPathComponent)
                if imageViewUnWrapped.image == nil {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        let downloadedImage = self.httpClient.downloadImage(coverUrl as String)
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            imageViewUnWrapped.image = downloadedImage
                            self.persistencyManager.saveImage(downloadedImage, filename: coverUrl.lastPathComponent)
                        })
                    })
                }
        }
    }
}