//
//  MemeEditorViewController.swift
//  HPL-MemeMe
//
//  Created by Rob Sutherland on 2016-10-08.
//  Copyright © 2016 HPL Software. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        imagePickerView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.subscribeToKeyboardNotifications()
        
        setupTextFieldParams(textField: textBoxTop)
        setupTextFieldParams(textField: textBoxBottom)
        
        if(imagePickerView.image == nil){
          activityButton.isEnabled = false
        }else{
            activityButton.isEnabled = true
        }
    }
    
    func setupTextFieldParams(textField: UITextField){
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = textBoxViewControllerDelegate
        textField.textAlignment = NSTextAlignment.center
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
       setupImagePickerInstance(imagePickerControllerSourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        setupImagePickerInstance(imagePickerControllerSourceType: UIImagePickerControllerSourceType.camera)
    }
    
    func setupImagePickerInstance(imagePickerControllerSourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = imagePickerControllerSourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
            activityButton.isEnabled = true
        }else{
           activityButton.isEnabled = false
        }
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
        
        //save the meme object
        _ = MemeObject( upperString: textBoxTop.text!,lowerString: textBoxBottom.text!, memeImage: memedImage, origImage:imagePickerView.image)
        
    }
    
    @IBAction func openShareActivityAction(_ sender: AnyObject) {
        
        //create the memed image
        memedImage = generateMemedImage()
        
        //open the activity controller and pass in the saved meme object
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //setup the completion handler for the activity view
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if success{
            
                //save the mem object
                self.saveMemeObject()
                
                //clear the meme editor
                self.clearMemeArea()
                
                //dismiss the activity controller
                self.dismiss(animated: true, completion: nil)
                
                //setup alert controller
                let alertController = UIAlertController(title: "Success", message: "Successfully Saved Meme!!", preferredStyle: .alert)
                
                //present the alert to the user in the center of the screen
                self.present(alertController, animated: true, completion: nil)
                
                //get rid of the alert after 2 seconds
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        //present the activity controller
        self.present(controller, animated: true, completion: nil)

    }
    
    @IBAction func clearMemeArea(){
        
        textBoxTop.text = "TOP"
        textBoxBottom.text = "BOTTOM"
        imagePickerView.image = nil
        activityButton.isEnabled = false
    }
    
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        sourceImageToolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        sourceImageToolBar.isHidden = false
        
        return memedImage
    }
    
    

}

