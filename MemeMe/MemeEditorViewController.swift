//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Troutslayer33 on 5/10/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//
//  This controller presents a meme editor and controls all of the functionality and display

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Hide status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    @IBOutlet weak var memeToolbar: UIToolbar!
    @IBOutlet weak var memeNavBar: UINavigationBar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeWidthAttributeName: -5.0
    ]
    
    // Text Field Delegate objects
    let memeDelegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set view background color
        self.view.backgroundColor = UIColor.blackColor()
        
        // Set the delegates
        self.textFieldTop.delegate = memeDelegate
        self.textFieldBottom.delegate = memeDelegate
        
        // Set Textfield Attributes
        textFieldTop.defaultTextAttributes = memeTextAttributes
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        
        // Set initial text value
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        
        // Set Text Alignment and background color
        textFieldTop.backgroundColor = UIColor.clearColor()
        textFieldBottom.backgroundColor = UIColor.clearColor()
        textFieldTop.textAlignment = .Center
        textFieldBottom.textAlignment = .Center
    }
    override func viewWillAppear(animated: Bool) {
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
        // enable camera button if device has a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe to keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // populate image in meme editor after user picks image
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // dismiss image picker controller when user taps cancel
    
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController){
        dismissViewControllerAnimated(true , completion: nil)
    }
    
    //  if no memes sent present alert view else dismiss meme editor when user taps cancel
    
    @IBAction func CancelMemeEditor(sender: AnyObject) {
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            let alertController = UIAlertController(title: "Oops!", message: "You haven't sent any memes yet", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Let's Meme", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)}
        else {
            
            self.dismissViewControllerAnimated(true, completion: nil)}
    }
    
    // Launch image picker controller for photo library when user taps "album" button
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // when user taps share button a "meme image" is create and passed to the activity view controller
    
    @IBAction func shareMeme(sender: AnyObject) {
        let image = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = saveMemeAfterSharing
    }
    
    // brings up the camera when the "camera icon" is tapped
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // function called from view will appear to subscribe to keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    // if the user is editing the bottom text field this slides the view up so keyboard does not block input
    
    func keyboardWillShow(notification: NSNotification) {
        if self.textFieldBottom.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // when the users finishes editing bottom text field this slides the view back to original position
    
    func keyboardWillHide(notification: NSNotification) {
        if self.textFieldBottom.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // returns the height of the keyboard and used in keyboardwillshow and keyboardwillhide to slide view the height of the keyboard
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    

    
    func saveMeme() {
        
        //Create the meme
        var meme = Meme( textFieldTop: textFieldTop.text!, textFieldBottom: textFieldBottom.text!, image:
            imageView.image!, memeImage: generateMemedImage())
        
        // Add it to the memes array on the AppDelegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        
        self.memeNavBar.hidden = true
        self.memeToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        
        self.memeNavBar.hidden = false
        self.memeToolbar.hidden = false
        
        return memedImage
    }
    
    // saves the meme after sharing
    
    func saveMemeAfterSharing(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) {
        if completed {
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}




