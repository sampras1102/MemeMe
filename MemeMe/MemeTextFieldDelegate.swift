//
//  MemeTextFieldDelegate
//  MemeMe
//
//  Created by Chris Supranowitz on 5/18/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    var initText = ""
    
    init(initialText t:String) {
        initText = t
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text == ""){
            textField.text = initText
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        if (textField.text == initText){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
