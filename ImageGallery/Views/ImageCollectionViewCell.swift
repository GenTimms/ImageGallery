//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 05/03/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
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
}
