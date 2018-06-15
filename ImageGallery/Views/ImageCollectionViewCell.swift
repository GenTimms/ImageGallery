//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 05/03/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    //Option to set directily or through url
    
    
//    var imageURL: URL? {
//        didSet {
//            image = nil
//            fetchImage()
//        }
//    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            spinner.stopAnimating()
            imageView.image = newValue
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
//    private func fetchImage() {
//        if let url = imageURL {
//            spinner.startAnimating()
//            let request = URLRequest(url: url.imageURL)
//            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//                DispatchQueue.main.async {
//                    if url == self?.imageURL {
//                        if let error = error {
//                            print("Failed with error: \(error)")
//                        }
//                        if let imageData = data, let image = UIImage(data: imageData) {
//                            self?.image = image
//
//                        } else {
//                            self?.image = UIImage(named: "loadFailed")
//                        }
//                    }
//                }
//            }
//
//            let capacity = Double(URLSession.shared.configuration.urlCache?.diskCapacity ?? 4)
//            let usage = Double(URLSession.shared.configuration.urlCache?.currentDiskUsage ?? 2)
//            print("Session Cache: \(String(describing: URLSession.shared.configuration.urlCache))")
//            print("Session Current Disk Usage: \(usage)")
//            print("Session Current Memory Usage: \(String(describing: URLSession.shared.configuration.urlCache?.currentMemoryUsage))")
//             print("Session Disk Capacity: \(capacity)")
//             print("Session Memory Capacity: \(String(describing: URLSession.shared.configuration.urlCache?.memoryCapacity))")
//            print("Session Disk Percentage: \((usage/capacity)*100.0)%")
//
//            task.resume()
//        }
//    }
}
                
//            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                let urlContents = try? Data(contentsOf: url.imageURL)
//                DispatchQueue.main.async {
//                    if let imageData = urlContents, url == self?.imageURL {
//                        self?.image = UIImage(data: imageData)
//                    } else if url == self?.imageURL {
//                        self?.image = UIImage(named: "sadFace")
//                    }
//                }

