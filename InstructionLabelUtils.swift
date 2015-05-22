//
//  InstructionLabelUtils.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/21/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import Foundation
import UIKit

class InstructionLabelUtils
{
    class func createLabelInViewController(view: UIViewController, text: String) -> UILabel
    {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = NSTextAlignment.Center
        label.text = text
        label.textColor = UIColor.blackColor()
        label.layer.zPosition = 1000
        label.sizeToFit()
        view.view.addSubview(label)
        centerLabelInViewFrame(label)
        return label
    }
    
    class func centerLabelInViewFrame(label: UILabel){
        if let v = label.superview {
            var frameSize = v.frame
            label.center = CGPointMake(frameSize.width/2.0, frameSize.height/2.0)
            label.bringSubviewToFront(v)
        }
    }
}