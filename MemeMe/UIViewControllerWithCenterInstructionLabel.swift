//
//  UIViewControllerWithCenterInstructionLabel
//  MemeMe
//
//  Created by Chris Supranowitz on 5/21/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import Foundation
import UIKit

class UIViewControllerWithCenterInstructionLabel:UIViewController{
    
    var instructionLabel:CenteredInstructionUILabel?
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        if let l = instructionLabel{
            l.hidden = hideInstructionLabel()
        }
    }
    
    func hideInstructionLabel() -> Bool{
        //should be overriden
        return false
    }
}