//
//  Utilities.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 05/03/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit
import Foundation

extension URL {
    var imageURL: URL {

            for query in query?.components(separatedBy: "&") ?? [] {
                let queryComponents = query.components(separatedBy: "=")
                if queryComponents.count == 2 {
                    if queryComponents[0] == "imgurl", let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                        return url
                    }
                }
            }
            return self.baseURL ?? self
        }
    }

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

extension UIImage
    {
        private static let localImagesDirectory = "UIImage.storeLocallyAsJPEG"
        
        static func urlToStoreLocallyAsJPEG(named: String) -> URL? {
            var name = named
            let pathComponents = named.components(separatedBy: "/")
            if pathComponents.count > 1 {
                if pathComponents[pathComponents.count-2] == localImagesDirectory {
                    name = pathComponents.last!
                } else {
                    return nil
                }
            }
            if var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                url = url.appendingPathComponent(localImagesDirectory)
                do {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                    url = url.appendingPathComponent(name)
                    if url.pathExtension != "jpg" {
                        url = url.appendingPathExtension("jpg")
                    }
                    return url
                } catch let error {
                    print("UIImage.urlToStoreLocallyAsJPEG \(error)")
                }
            }
            return nil
        }
        
        func storeLocallyAsJPEG(named name: String) -> URL? {
            if let imageData = UIImageJPEGRepresentation(self, 1.0) {
                if let url = UIImage.urlToStoreLocallyAsJPEG(named: name) {
                    do {
                        try imageData.write(to: url)
                        return url
                    } catch let error {
                        print("UIImage.storeLocallyAsJPEG \(error)")
                    }
                }
            }
            return nil
        }
}
