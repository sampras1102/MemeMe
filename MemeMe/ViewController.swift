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
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var topDel = MemeTextFieldDelegate(initialText: "TOP") //can't use a constant to define initial text because I am instantiating the object here
    var bottomDel = MemeTextFieldDelegate(initialText: "BOTTOM")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
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
    
    @IBAction func share(sender: AnyObject) {
        var memedImage = generateMemedImage()
        var avc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        avc.completionWithItemsHandler = {activityType, completed, returnedItems, error in
            if completed{
            self.save(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.presentViewController(avc, animated: true, completion: nil)
        
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
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool{
        return true
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
    
    func save(memedImage:UIImage) {
        //Create the meme
        var meme = Meme(topString: topText.text, bottomString: bottomText.text, originalImage: imageView.image!, memedImage: memedImage)
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        println("saving the meme")
    }
    
    func generateMemedImage() -> UIImage {
        
        toolbar.hidden = true
        navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
}

