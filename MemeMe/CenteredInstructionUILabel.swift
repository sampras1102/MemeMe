//
//  CenteredInstructionUILabel.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/23/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class CenteredInstructionUILabel: UILabel {

    init(superview: UIView, text: String){
        // the point of this subclass is to make a label centered on some superview, so it needs to be initialized with a superview
        super.init(frame: CGRect(x: 0,y: 0,width: 100,height: 50))
        superview.addSubview(self)
        self.font = UIFont.systemFontOfSize(12)
        self.adjustsFontSizeToFitWidth = false
        self.textAlignment = NSTextAlignment.Center
        self.text = text
        self.layer.zPosition = 1000
        self.sizeToFit()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: 0)
        superview.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1, constant: 0)
        superview.addConstraint(yCenterConstraint)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
