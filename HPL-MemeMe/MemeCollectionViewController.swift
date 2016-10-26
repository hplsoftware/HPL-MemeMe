//
//  MemeCollectionViewController.swift
//  HPL-MemeMe
//
//  Created by Rob Sutherland on 2016-10-16.
//  Copyright © 2016 HPL Software. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [MemeObject] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        var meme = memes
        
        // Provoke the table view data source protocol methods to be called when subesequent memes are added to the memes collection.
        self.collectionView?.reloadData()
        
        //show the taskbar to allow navigartion between table or collection view
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        //setup the flow layout parameters
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        let size = CGSize(width: dimension, height: dimension)
        flowLayout.itemSize = size
        
        //setup for data and delegate
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // grab the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //grab our custom cell by the name we gave it in storyboard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath as IndexPath) as! MemeCollectionViewCell

        //grab the mem object at this path
        let meme = self.memes[indexPath.item]
        
        //set the properties of the cell with the objects data
        let imageView = UIImageView(image: meme.memeImage)
        cell.backgroundView = imageView
        
        //return it for use
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //instantiate the detail controller
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //grab the instance at this index
        detailController.meme = self.memes[indexPath.row]
        
        //push it onto the stack
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
