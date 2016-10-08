//
//  TextBoxViewControllerDelegate.swift
//  HPL-MemeMe
//
//  Created by Rob Sutherland on 2016-10-08.
//  Copyright © 2016 HPL Software. All rights reserved.
//

import UIKit

class TextBoxViewControllerDelegate: UIViewController, UITextFieldDelegate {

  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
