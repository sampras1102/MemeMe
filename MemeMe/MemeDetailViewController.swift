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
    @IBOutlet weak var toolbar: UIToolbar!
    
    var index:Int? //index of meme in memes array

    override func viewDidLoad() {
        super.viewDidLoad()
        //add nav bar button for edit action
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true

        if let i = index{
            println("setting meme")
            imageView.image = ((UIApplication.sharedApplication().delegate) as! AppDelegate).memes[i].memedImage
        }
        //make sure the bars are always visible when the view initially appears
        navigationController?.setNavigationBarHidden(false, animated:false)
        toolbar.hidden = false
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        if let i = index{
            ((UIApplication.sharedApplication().delegate) as! AppDelegate).memes.removeAtIndex(i)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func edit() {
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! ViewController
        if let i = index{
            editController.existingMeme = ((UIApplication.sharedApplication().delegate) as! AppDelegate).memes[i]
            editController.existingMemeIndex = i
        }
        self.presentViewController(editController, animated: true, completion: nil)
        
    }
    
    //from http://stackoverflow.com/questions/26273672/how-to-hide-status-bar-and-navigation-bar-when-tap-device
    //and http://stackoverflow.com/questions/3775577/uiimageview-touch-event
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch: UITouch? = touches.first as? UITouch

        if (touch?.view == imageView || touch?.view == imageView.superview) {
            toggle()
        }
    }
    
    func toggle() {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true) //or animated: false
        toolbar.hidden = (toolbar.hidden == false)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }

}
