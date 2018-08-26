//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 13/03/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageView = UIImageView()
    var scrollView = UIScrollView()

    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            scrollView.zoomScale = 1.0
            imageView.image = newValue
            let size = newValue?.size ?? CGSize.zero
            imageView.sizeToFit()
            scrollView.contentSize = size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Deletion
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteImage))
        self.navigationItem.rightBarButtonItem = deleteButton
        deleteButton.isEnabled = deleteHandler != nil
        
        //Scroll view
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 10
        
        //Constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK: - Image Deletion
    var deleteButton = UIBarButtonItem()
    var deleteHandler: (() -> Void)? { didSet {
        if deleteHandler != nil {
            deleteButton.isEnabled = true
        }
        }}
    
    @objc func deleteImage() {
        presentDeleteWarning()
    }
    
    private func presentDeleteWarning() {
        if let handler = self.deleteHandler {
            let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this Image?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {   action in
                handler()
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    //MARK: - Scroll View Zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var userDidZoom = false
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        userDidZoom = true
    }

    override func viewDidLayoutSubviews() {
        if !userDidZoom {
            scrollView.zoomScale = 1
            scrollView.zoom(to: rectToZoom(), animated: false)
        }
    }
    
    func rectToZoom() -> CGRect {
        let imageWidth = imageView.frame.width
        let imageHeight = imageView.frame.height
        var rectToZoom = CGRect()
        let viewAspectRatio = scrollView.bounds.width / scrollView.bounds.height
        
        if imageWidth/viewAspectRatio < imageHeight {
            let height = imageWidth/viewAspectRatio
            let size = CGSize(width: imageWidth, height: imageWidth/height)
            let origin = CGPoint(x: 0.0, y: imageHeight/2 - height/2)
            rectToZoom = CGRect(origin: origin, size: size)
        } else {
            let width = imageHeight * viewAspectRatio
            let size = CGSize(width: width, height: imageHeight)
            let origin = CGPoint(x: imageWidth/2 - width/2, y: 0.0)
            rectToZoom = CGRect(origin: origin, size: size)
        }
        return rectToZoom
    }
}
