//
//  PersistencyManager.swift
//  BlueLibrarySwift
//
//  Created by Prajwal Kedilaya on 1/31/16.
//  Copyright © 2016 Raywenderlich. All rights reserved.
//

import UIKit

class PersistencyManager {
    private var albums = [Album]()
    
     init() {
        if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")) {
            let unarchiveAlbums = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Album]?
            if let unwrappedAlbum = unarchiveAlbums {
                albums = unwrappedAlbum
            }
        } else {
            createPlaceholderAlbum()
        }
    }
    
    func createPlaceholderAlbum() {
        //Dummy list of albums
        let album1 = Album(title: "Best of Bowie",
            artist: "David Bowie",
            genre: "Pop",
            coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_david_bowie_best_of_bowie.png",
            year: "1992")
        
        let album2 = Album(title: "Falling Forward",
            artist: "Basque",
            genre: "Pop",
            coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_basque_falling_forward.png",
            year: "2001")
        
        let album3 = Album(title: "Dream of the Blue Turtles",
            artist: "Sting",
            genre: "Pop",
            coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_sting_dream_of_the_blue_turtles.png",
            year: "1985")
        
        let album4 = Album(title: "Rattle and Hum",
            artist: "U2",
            genre: "Pop",
            coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_u2_rattle_and_hum.png",
            year: "1988")
        
        let album5 = Album(title: "American Pie",
            artist: "Madonna",
            genre: "Pop",
            coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_madonna_american_pie.png",
            year: "2000")
        albums = [album1, album2, album3, album4, album5]
        saveAlbums()
    }
    
    func getAlbums() -> [Album] {
        return albums
    }
    
    func addAlbum(album: Album, index: Int) {
        if (albums.count >= index) {
            albums.insert(album, atIndex: index)
        } else {
            albums.append(album)
        }
    }
    
    func deleteAlbumAtIndex(index: Int) {
        albums.removeAtIndex(index)
    }
    
    func saveImage(image: UIImage, filename: String) {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        if let data = UIImagePNGRepresentation(image) {
            data.writeToFile(path, atomically: true)
        }
        
    }
    
    func getImage(filename: String) -> UIImage? {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        
        if let data = try? NSData(contentsOfFile: path, options: NSDataReadingOptions.UncachedRead) {
            return UIImage(data: data)
        }
        else {
            return nil
        }
    }
    
    func saveAlbums() {
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/albums.bin")
        let data = NSKeyedArchiver.archivedDataWithRootObject(albums)
        data.writeToFile(filename, atomically: true)
    }
}