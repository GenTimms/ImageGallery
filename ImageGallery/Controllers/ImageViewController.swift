//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 13/03/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    private var userDidZoom = false
    
    var scrollView = UIScrollView()
    var imageView = UIImageView()
    var deleteButton = UIBarButtonItem()
    
    var deleteHandler: (() -> Void)? {didSet {
        if deleteHandler != nil {
            deleteButton.isEnabled = true
        }
        }}
    
    
    //fetch image here? or before load vc? set fetch image as a url extension method? so can be reused by the cell and here
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
            //zoom to fit image in scrollview - scroll to rect method from example apps?
        }
    }
    
    func presentDeleteWarning() {
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
    
    @objc func deleteImage() {
        presentDeleteWarning()

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteImage))
        self.navigationItem.rightBarButtonItem = deleteButton
        deleteButton.isEnabled = deleteHandler != nil
   
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 10
        
        // CONSTRAINTS
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        userDidZoom = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
