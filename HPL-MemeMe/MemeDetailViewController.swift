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
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
        NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
    
     let textBoxViewControllerDelegate = TextBoxViewControllerDelegate()
    
    @IBOutlet var memTopText: UITextField!
    @IBOutlet var memImageView: UIImageView!
    @IBOutlet var memeBottomText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupTextFieldParams(textField: UITextField){
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = textBoxViewControllerDelegate
        textField.textAlignment = NSTextAlignment.center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTextFieldParams(textField: memTopText)
        setupTextFieldParams(textField: memeBottomText)
        
        self.memTopText.text = self.meme.upperString
        self.memeBottomText.text = self.meme.lowerString
        self.memImageView?.image = self.meme.origImage
        
        self.tabBarController?.tabBar.isHidden = true
       
    }

}
