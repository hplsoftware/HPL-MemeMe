//
//  ViewController.swift
//  HPL-MemeMe
//
//  Created by Rob Sutherland on 2016-10-08.
//  Copyright © 2016 HPL Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet var imagePickerView: UIImageView!
    
    @IBOutlet var textBoxTop: UITextField!
    @IBOutlet var textBoxBottom: UITextField!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var sourceImageToolBar: UIToolbar!
    @IBOutlet var activityButton: UIBarButtonItem!
    
    var memedImage: UIImage!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSBackgroundColorAttributeName: UIColor.clear,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
        NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
    
    let textBoxViewControllerDelegate = TextBoxViewControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        imagePickerView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.subscribeToKeyboardNotifications()
        
        textBoxTop.defaultTextAttributes = memeTextAttributes
        textBoxBottom.defaultTextAttributes = memeTextAttributes
        
        textBoxTop.textAlignment = NSTextAlignment.center
        textBoxBottom.textAlignment = NSTextAlignment.center
        
        textBoxTop.delegate = textBoxViewControllerDelegate
        textBoxBottom.delegate = textBoxViewControllerDelegate
        
//        if(imagePickerView.image != nil){
//            activityButton.isEnabled = true
//        }else{
//            activityButton.isEnabled = false
//        }
        
        //clearMemeArea()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
            
        }
        activityButton.isEnabled = true
    }
    
   
    
    func keyboardWillShow(notification: NSNotification) {
        if textBoxBottom.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textBoxBottom.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
        
    }
    
    func saveMemeObject() {
        
        //create the memed image
        memedImage = generateMemedImage()
        
        //Create the meme object
        _ = MemeObject( upperString: textBoxTop.text!,lowerString: textBoxBottom.text!, memeImage: memedImage, origImage:imagePickerView.image)
        
    }
    
    @IBAction func openShareActivityAction(_ sender: AnyObject) {
        
        saveMemeObject()
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionHandler = {(activityType, completed:Bool) in
            if !completed {
                //cancelled
                return
            }
            
            //shared successfully
            
           self.clearMemeArea()
            self.dismiss(animated: true, completion: nil)
        }
        
        self.present(controller, animated: true, completion: nil)

    }
    
    @IBAction func clearMemeArea(){
        
        textBoxTop.text = "TOP"
        textBoxBottom.text = "BOTTOM"
        imagePickerView.image = nil
        activityButton.isEnabled = false
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navigationBar.isHidden = true
        sourceImageToolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar       
        navigationBar.isHidden = false
        sourceImageToolBar.isHidden = false
        
        return memedImage
    }
    
    

}

