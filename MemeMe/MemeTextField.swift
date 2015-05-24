//
//  MemeTextField
//  MemeMe
//
//  Created by Chris Supranowitz on 5/23/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class MemeTextField: UITextField{

    var initialText = ""
    
    init(initialText t:String) {
        initialText = t
        super.init(frame: CGRect(x: 0,y: 0,width: 100,height: 50))
        self.text = initialText
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        self.defaultTextAttributes = memeTextAttributes
        self.autocapitalizationType = UITextAutocapitalizationType.Words
        self.textAlignment = NSTextAlignment.Center //set this after the defaultTextAttributes
        self.adjustsFontSizeToFitWidth = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
