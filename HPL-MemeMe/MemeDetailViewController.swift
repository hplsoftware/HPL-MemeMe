//
//  MemeDetailViewController.swift
//  HPL-MemeMe
//
//  Created by Rob Sutherland on 2016-10-17.
//  Copyright © 2016 HPL Software. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: MemeObject!
    
    @IBOutlet var memImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memImageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //display the image
        memImageView?.image = self.meme.memeImage
        
        //hide the taskbar
        tabBarController?.tabBar.isHidden = true
       
    }
}
