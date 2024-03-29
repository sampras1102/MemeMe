//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/15/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class ViewController : UIViewControllerWithCenterInstructionLabel, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var topText = MemeTextField(initialText: "TOP")
    var bottomText = MemeTextField(initialText: "BOTTOM")
    var existingMemeIndex = -1
    var existingMeme:Meme?
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
        instructionLabel = CenteredInstructionUILabel(superview: view, text: "Take a picture or load an image to create a meme")

        view.addSubview(topText)
        view.addSubview(bottomText)
        topText.delegate = self
        bottomText.delegate = self
        topText.hidden = true
        bottomText.hidden = true
        
        setMeme(existingMeme)
    }
    
    override func hideInstructionLabel() -> Bool {
        return (imageView.image != nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // call any manual layout functions here
        setTextBoxPosition()
    }
    
    func afterImageSet(){
        shareButton.enabled = true
        topText.hidden = false
        bottomText.hidden = false
        if let l = instructionLabel{
            l.hidden = true
        }
        setTextBoxPosition()
    }
    
    func setMeme(meme: Meme?){
        if let m = meme {
            imageView.image = m.originalImage
            topText.text = m.topString
            bottomText.text = m.bottomString
            afterImageSet()
        }
    }
    
    func setTextBoxPosition(){
        //this ensures that the text boxes are always on the image
        if let i = imageView.image{
            let imageFrame = frameForImage(i)
            
            var frameSize = topText.superview?.frame
            topText.frame = CGRect(x:0,y:0,width:imageFrame.width, height: 50)
            bottomText.frame = CGRect(x:0,y:0,width:imageFrame.width, height: 50)
            topText.center = CGPointMake(frameSize!.width/2.0, imageFrame.origin.y + 0.25*imageFrame.height)
            bottomText.center = CGPointMake(frameSize!.width/2.0, imageFrame.origin.y + 0.75*imageFrame.height)
        }
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerControl = UIImagePickerController()
        pickerControl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerControl.delegate = self
        presentViewController(pickerControl, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil) // dismiss the modal view controller and return to the presenter
    }

    @IBAction func share(sender: AnyObject) {
        var memedImage = generateMemedImage()
        var avc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        avc.completionWithItemsHandler = {activityType, completed, returnedItems, error in
            if completed{
            self.save(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil) // dismiss the modal view controller and return to the presenter
            }
        }
        presentViewController(avc, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerControl = UIImagePickerController()
        pickerControl.sourceType = UIImagePickerControllerSourceType.Camera
        pickerControl.delegate = self
        presentViewController(pickerControl, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            afterImageSet()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
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
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func save(memedImage:UIImage) {
        var meme = Meme(topString: topText.text, bottomString: bottomText.text, originalImage: imageView.image!, memedImage: memedImage)
        var appDel = (UIApplication.sharedApplication().delegate) as! AppDelegate
        if existingMemeIndex > -1 {
            //replace the current saved meme with the edited version
            appDel.memes[existingMemeIndex] = meme
        }
        else{
            //Create the meme
            appDel.memes.append(meme)
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        toolbar.hidden = true
        navigationBar.hidden = true
        
        let imageFrame = frameForImage(imageView.image!)
        
        //from: http://stackoverflow.com/questions/12687909/ios-screenshot-part-of-the-screen
        // Render view to an image
        //first we will make an UIImage from your view
        UIGraphicsBeginImageContext(view.bounds.size);
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        var sourceImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //now we will position the image, X/Y away from top left corner to get the portion we want
        UIGraphicsBeginImageContext(imageFrame.size)
        sourceImage.drawAtPoint(CGPoint(x: -imageFrame.origin.x, y: -imageFrame.origin.y))
        var memedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        toolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
    
    func frameForImage(image: UIImage) -> CGRect {
        //from: http://stackoverflow.com/questions/389342/how-to-get-the-size-of-a-scaled-uiimage-in-uiimageview/4987554#4987554
        var imageRatio = CGFloat(image.size.width / image.size.height)
        var scale:CGFloat = 0
        var width:CGFloat = 0
        var height:CGFloat = 0
        var topLeftX:CGFloat = 0
        var topLeftY:CGFloat = 0
        
        var viewRatio = CGFloat(imageView.frame.size.width / imageView.frame.size.height)
        
        if(imageRatio < viewRatio)
        {
            scale = CGFloat(imageView.frame.size.height / image.size.height)
            width = CGFloat(scale * image.size.width)
            topLeftX = CGFloat((imageView.frame.size.width - width) * 0.5);
            
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height);
        }
        else
        {
            scale = imageView.frame.size.width / image.size.width
            height = scale * image.size.height
            topLeftY = (imageView.frame.size.height - height) * 0.5;
            
            return CGRect(x: 0, y: topLeftY, width: imageView.frame.size.width, height: height);
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let t = textField as? MemeTextField{
            if (t.text == ""){
                t.text = t.initialText
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        if let t = textField as? MemeTextField{
            if (t.text == t.initialText){
                t.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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
        navigationBar.hidden = (navigationBar.hidden == false)
        toolbar.hidden = (toolbar.hidden == false)
    }
    
}