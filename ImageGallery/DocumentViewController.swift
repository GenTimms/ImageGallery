//
//  DocumentViewController.swift
//  ImageGallery
//
//  Created by Genevieve Timms on 13/04/2018.
//  Copyright © 2018 GMJT. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var documentNameLabel: UILabel!
    
    var document: UIDocument?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        document?.open(completionHandler: { (success) in
            if success {
                self.documentNameLabel.text = self.document?.fileURL.lastPathComponent
            } else {
               self.displayErrorAlert()
            }
        })
    }
    
    private func displayErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Unable To Open Document", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}
