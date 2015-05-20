//
//  ViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/15/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class ViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var topDel = MemeTextFieldDelegate(initialText: "TOP") //can't use a constant to define initial text because I am instantiating the object here
    var bottomDel = MemeTextFieldDelegate(initialText: "BOTTOM")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Make sure I am handling the optionals in an acceptable way
        topText.delegate = topDel
        bottomText.delegate = bottomDel
        setTextBoxProps(topText, initText: topDel.initText)
        setTextBoxProps(bottomText, initText: bottomDel.initText)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextBoxProps(tb: UITextField, initText: String){
        //tb.placeholder = initText //not sure if we are supposed to use a placeholder
        tb.text = initText
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        tb.defaultTextAttributes = memeTextAttributes
        tb.textAlignment = NSTextAlignment.Center //set this after the defaultTextAttributes
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        println("in pick an image")
        let pickerControl = UIImagePickerController()
        pickerControl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerControl.delegate = self
        self.presentViewController(pickerControl, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        println("in pick an image")
        let pickerControl = UIImagePickerController()
        pickerControl.sourceType = UIImagePickerControllerSourceType.Camera
        pickerControl.delegate = self
        self.presentViewController(pickerControl, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        //didFinishPickingMediaWithInfo is the external name
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            println("image picked")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //from http://stackoverflow.com/questions/12173802/trying-to-find-which-text-field-is-active-ios
        //and http://stackoverflow.com/questions/9474160/get-uitextfield-y-coordinate-on-uiview-level
        for view in self.view.subviews {
            if (view.isFirstResponder()) {
                let tbBottom = view.frame.maxY
                let frameBottom = self.view.frame.maxY
                let keyHeight = getKeyboardHeight(notification)
                self.view.frame.origin.y -= max(0,getKeyboardHeight(notification) - (frameBottom - tbBottom) + 10) //shift frame if this value is positive.  Puts the text box right above the keyboard
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
//    Let’s think about the specifications for the MemeMe textfields.
//    
//    1. There should be two textfields, reading “TOP” and “BOTTOM” when a user opens the Meme Editor. You can set a textfield’s initial text by setting its text property in viewDidLoad.
//    
//    2. Text should be center-aligned. For this you can set the textfield’s textAlignment property in viewDidLoad.
//    
//    3. Text should approximate the "Impact" font, all caps, white with a black outline. For this we will make use of the defaultTextAttributes dictionary that governs font appearance. Details to come in the next segment.
//    
//    4. When a user taps inside a textfield, the default text should clear. This can be accomplished in textFieldDidBeginEditing method. Be sure to remove default text only, not user entered text.
//    
//    5. When a user presses return, the keyboard should be dismissed. This can be accomplished in textFieldShouldReturn.
}

