//
//  Meme.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/19/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

struct Meme {
    var topString:String
    var bottomString:String
    var originalImage:UIImage
    var memedImage:UIImage
    
    init(topString:String, bottomString:String, originalImage:UIImage, memedImage:UIImage){
        self.topString = topString
        self.bottomString = bottomString
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
