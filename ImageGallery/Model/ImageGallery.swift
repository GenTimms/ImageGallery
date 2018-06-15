//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 05/03/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import Foundation
import UIKit

struct ImageGallery: Codable {
    
    var images = [ImageData]()

    struct ImageData: Codable, Equatable {
        let url: URL
        let aspectRatio: CGFloat
        //what do you want to communicate? if you can't find image locally try original url again then backup? orrrr? array of urls? try in order?
        //who knows about what?
        // pass image fetcher an array of urls tries each one in turn then if back up creates local and inserts at start? way to show url? if interested? in image viewer?
        //TODO: let localUrl: URL?
    }

    mutating func addImage(at url: URL, aspectRatio: CGFloat) {
     images.append(ImageData(url: url, aspectRatio: aspectRatio))
    }
    
    init() {
        
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data?
    {
        return try? JSONEncoder().encode(self)
    }
    
}
