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
    //TODO: Implement this as a new ViewController class and make the collection and table views inherit from this instead of UIViewController.  It will be much cleaner that way and I can also ensure that it gets re-laid out upon rotation
    class func createLabelInViewController(viewController: UIViewController, text: String) -> UILabel
    {
        var label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.adjustsFontSizeToFitWidth = false
        label.textAlignment = NSTextAlignment.Center
        label.text = text
        label.textColor = UIColor.blackColor()
        label.layer.zPosition = 1000
        label.sizeToFit()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        viewController.view.addSubview(label)
        //centerLabelInViewFrame(label)
        
        let xCenterConstraint = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: viewController.view, attribute: .CenterX, multiplier: 1, constant: 0)
        viewController.view.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: viewController.view, attribute: .CenterY, multiplier: 1, constant: 0)
        viewController.view.addConstraint(yCenterConstraint)
        
        return label
    }
    
    class func centerLabelInViewFrame(label: UILabel){
//        if let v = label.superview {
//            var frameSize = v.frame
//            label.center = CGPointMake(frameSize.width/2.0, frameSize.height/2.0)
//            label.bringSubviewToFront(v)
//        }
    }
}