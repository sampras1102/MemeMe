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
        text = initialText
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        defaultTextAttributes = memeTextAttributes
        autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        textAlignment = NSTextAlignment.Center //set this after the defaultTextAttributes
        adjustsFontSizeToFitWidth = true
        layer.zPosition = 1000
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
