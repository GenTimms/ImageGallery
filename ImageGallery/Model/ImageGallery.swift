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
    }
    
    mutating func addImage(at url: URL, aspectRatio: CGFloat) {
        images.append(ImageData(url: url, aspectRatio: aspectRatio))
    }
    
    init() {}
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
