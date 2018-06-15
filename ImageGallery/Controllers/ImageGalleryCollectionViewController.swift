//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 05/03/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate {

    // MARK: - Model
    var imageGallery = ImageGallery()


    //MARK: - UIDocument
    var document: ImageGalleryDocument?
    
    func documentChanged() {
        document?.imageGallery = imageGallery
        
        if document?.imageGallery != nil {
            document?.updateChangeCount(.done)
        }
    }
 
    @IBAction func close(_ sender: UIBarButtonItem) {
        if document?.imageGallery != nil {
            document?.thumbnail = (collectionView?.visibleCells.first as? ImageCollectionViewCell)?.image
        }
        
        presentingViewController?.dismiss(animated: true)  {
            self.document?.close()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.dropDelegate = self
        collectionView?.dragDelegate = self
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(scaleImageWidth(recognizer:))))
        
        document?.open { success in
            if success {
                self.title = self.document?.localizedName
                self.imageGallery = self.document?.imageGallery ?? ImageGallery()
                self.collectionView?.reloadData()
            }
        }
    }
    
    //MARK: - UICollectionView Layout
    
    @IBOutlet weak var imageGalleryCollectionViewFlowLayout: UICollectionViewFlowLayout!
    private var itemWidth: CGFloat = 200
    
    
    @objc private func scaleImageWidth(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended: itemWidth = itemWidth*recognizer.scale; imageGalleryCollectionViewFlowLayout.invalidateLayout(); recognizer.scale = 1
        default: return
        }
    }
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell {
            let imageViewController = ImageViewController()
            imageViewController.image = cell.image
            imageViewController.deleteHandler = { [weak self] in
                    self?.imageGallery.images.remove(at: indexPath.item)
                    self?.collectionView?.deleteItems(at: [indexPath])
                    self?.documentChanged()
            }
            navigationController?.pushViewController(imageViewController, animated: true)
        }
    }


    // MARK: UICollectionViewFlowDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
            let height = imageGallery.images[indexPath.item].aspectRatio * itemWidth
            return CGSize(width: itemWidth, height: height)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGallery.images.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.spinner.startAnimating()
            let url = imageGallery.images[indexPath.item].url
            let request = URLRequest(url: url.imageURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Failed with error: \(error)")
                    }
                    if let imageData = data, let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            if let indexPath = collectionView.indexPath(for: imageCell) {
                                if url == self.imageGallery.images[indexPath.item].url {
                                    imageCell.image = image
                                }
                            }
                        }
                    } else {
                        if let indexPath = collectionView.indexPath(for: imageCell) {
                            if url == self.imageGallery.images[indexPath.item].url {
                                imageCell.image = UIImage(named: "loadFailed")
                            }
                        }
                    }
                }
            }
            task.resume()
            return imageCell
        }
        return cell
    }
    
    // MARK: - Dropping
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        
        return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self) || session.localDragSession != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    private var suppressBadURLWarnings = false
    private func presentBadURLWarning(for url: URL?) {
        if !suppressBadURLWarnings {
            let alert = UIAlertController(title: "Image Transfer Failed",
                                          message: "Couldn't transfer the dropped image from it's source.\nShow this warning in the furture?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Keep Warning",
                                          style: .default))
            alert.addAction(UIAlertAction(title: "Stop Warning",
                                          style: .destructive,
                                          handler: { action in
                                            self.suppressBadURLWarnings = true
                                            }
            ))
            present(alert, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            if let sourceIndex = item.sourceIndexPath {
                if let imageData = item.dragItem.localObject as?  ImageGallery.ImageData {
                    collectionView.performBatchUpdates( {
                        imageGallery.images.remove(at: sourceIndex.item)
                        imageGallery.images.insert(imageData, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndex])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    documentChanged()
                }
            } else {
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    
                    if let url = provider as? URL {
                        let request = URLRequest(url: url.imageURL)
                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                            DispatchQueue.main.async {
                                if let error = error {
                                    print("Failed with error: \(error)")
                                }
                                if let imageData = data, let image = UIImage(data: imageData) {
                                    let aspectRatio = image.size.height / image.size.width
                                    collectionView.performBatchUpdates ({
                                        self.imageGallery.images.insert(ImageGallery.ImageData(url: url, aspectRatio: aspectRatio), at: destinationIndexPath.item)
                                        collectionView.insertItems(at: [destinationIndexPath])
                                    })
                                    self.documentChanged()
                                    
                                } else {
                                    self.presentBadURLWarning(for: url)
                                }
                            }
                        }
                        task.resume()
                    }
                }
            }
        }
    }
    
    // MARK: Dragging
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = imageGallery.images[indexPath.item]
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = imageGallery.images[indexPath.item]
        return [dragItem]
    }

}
