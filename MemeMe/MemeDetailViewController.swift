//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/20/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme:Meme?
    var existingIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        //add nav bar button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        if let m = meme {
            imageView.image = m.memedImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //from http://stackoverflow.com/questions/26273672/how-to-hide-status-bar-and-navigation-bar-when-tap-device
    //and http://stackoverflow.com/questions/3775577/uiimageview-touch-event
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch? = touches.first as? UITouch
        
        if (touch?.view == imageView) {
            toggle()
        }
    }
    
    
    func edit() {

        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! ViewController
        if let m = self.meme{
            editController.existingMeme = m
            editController.existingIndex = existingIndex!
            self.presentViewController(editController, animated: true, completion: nil)
        }

    }
    
    func toggle() {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true) //or animated: false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

}
