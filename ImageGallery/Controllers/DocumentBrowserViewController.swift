//
//  DocumentBrowserViewController.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 13/04/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var template: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        additionalSafeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("ImageGallery.gallery")
            
            if template != nil {
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
            }
        }
    }
    
    // MARK: - UIDocumentBrowserViewControllerDelegate
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        let alert = UIAlertController(title: "Error", message: "Failed to import document at \(documentURL.absoluteString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Document Presentation
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController")
        
        if let imageGalleryViewController = documentViewController.contents as? ImageGalleryCollectionViewController {
            imageGalleryViewController.document = ImageGalleryDocument(fileURL: documentURL)
        }
        present(documentViewController, animated: true, completion: nil)
    }
}

