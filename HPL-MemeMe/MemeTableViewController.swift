//
//  MemeTableViewController.swift
//  HPL-MemeMe
//
//  Created by Rob Sutherland on 2016-10-17.
//  Copyright © 2016 HPL Software. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [MemeObject] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        _ = (UIApplication.shared.delegate as! AppDelegate).memes
        
        // Provoke the table view data source protocol methods to be called when subesequent memes are added to the memes collection.
        self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = "\(meme.upperString!) ... \(meme.lowerString!)"
        cell.imageView?.image = meme.memeImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //grab the instance at this index
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
