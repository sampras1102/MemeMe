//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/15/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class ViewController : UIViewControllerWithCenterInstructionLabel, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var topText = UITextField()
    var bottomText = UITextField()
    var existingIndex = -1
    var existingMeme:Meme?
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
        instructionLabel = CenteredInstructionUILabel(superview: self.view, text: "Take a picture or load an image to create a meme")
        //TODO: Make sure I am handling the optionals in an acceptable way
        topText.delegate = topDel
        bottomText.delegate = bottomDel
        setTextBoxProps(topText, initText: topDel.initText)
        setTextBoxProps(bottomText, initText: bottomDel.initText)
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
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
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
        if let l = self.instructionLabel{
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
    
    //TODO: Implement cancel button
    //TODO: Hide buttons on top
    //TODO: Add instructions when loading app
    
    func setTextBoxProps(tb: UITextField, initText: String){
        //tb.placeholder = initText //not sure if we are supposed to use a placeholder
        self.view.addSubview(tb)
        tb.text = initText
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        tb.defaultTextAttributes = memeTextAttributes
        tb.autocapitalizationType = UITextAutocapitalizationType.Words
        tb.textAlignment = NSTextAlignment.Center //set this after the defaultTextAttributes
        tb.adjustsFontSizeToFitWidth = true
        
    }
    
    func setTextBoxPosition(){
        if let i = imageView.image{
            let imageFrame = frameForImage(i)
            topText.layer.zPosition = 1000
            bottomText.layer.zPosition = 1000
            
            var frameSize = topText.superview?.frame
            topText.frame = CGRect(x:0,y:0,width:imageFrame.width, height: 50)
            bottomText.frame = CGRect(x:0,y:0,width:imageFrame.width, height: 50)
            topText.center = CGPointMake(frameSize!.width/2.0, imageFrame.origin.y + 0.25*imageFrame.height)
            bottomText.center = CGPointMake(frameSize!.width/2.0, imageFrame.origin.y + 0.75*imageFrame.height)
        }
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        println("in pick an image")
        let pickerControl = UIImagePickerController()
        pickerControl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerControl.delegate = self
        self.presentViewController(pickerControl, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil) // dismiss the modal view controller and return to the presenter
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
            afterImageSet()
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
        if existingIndex > -1{
            //TODO: Changed Meme to class but not sure if this is working correctly.  Thought the changes would automatically save, but they aren't.  Maybe just receive an index from the detail view and then edit that object directly
            existingMeme?.topString = topText.text
            existingMeme?.bottomString = bottomText.text
            existingMeme?.originalImage = imageView.image!
            existingMeme?.memedImage = memedImage
        }
        else{
            //Create the meme
            var meme = Meme(topString: topText.text, bottomString: bottomText.text, originalImage: imageView.image!, memedImage: memedImage)
            
            ((UIApplication.sharedApplication().delegate) as! AppDelegate).memes.append(meme)
            println(String(((UIApplication.sharedApplication().delegate) as! AppDelegate).memes.count) + " items in memes")
        }
        println("saving the meme")
    }
    
    func generateMemedImage() -> UIImage {
        
        toolbar.hidden = true
        navigationBar.hidden = true
        //from: http://stackoverflow.com/questions/12687909/ios-screenshot-part-of-the-screen
        // Render view to an image
//        let imageFrame = frameForImage(imageView.image!)

//        UIGraphicsBeginImageContext(imageFrame.size) //self.view.frame.size)
//        self.view.drawViewHierarchyInRect(imageFrame, afterScreenUpdates: true)   //self.view.frame, afterScreenUpdates: true)
//        let memedImage : UIImage =
//        UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        let imageFrame = frameForImage(imageView.image!)
        println("imageFrame \(imageFrame)")
        println("self.view.frame \(self.view.frame)")
        
        //first we will make an UIImage from your view
        UIGraphicsBeginImageContext(self.view.bounds.size);
        //self.view.layer.renderInContext(UIGraphicsGetCurrentContext());
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        var sourceImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //now we will position the image, X/Y away from top left corner to get the portion we want
        UIGraphicsBeginImageContext(imageFrame.size)
        sourceImage.drawAtPoint(CGPoint(x: 0, y: -imageFrame.origin.y))
        var memedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //UIImageWriteToSavedPhotosAlbum(memedImage,nil, nil, nil);
        
        toolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
    
    //from: http://stackoverflow.com/questions/389342/how-to-get-the-size-of-a-scaled-uiimage-in-uiimageview/4987554#4987554
    func frameForImage(image: UIImage) -> CGRect {
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

}

