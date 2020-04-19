//
//  ViewController.swift
//  MemeMe
//
//  Created by Abdalla Elshikh on 4/19/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    //Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var activityButton: UIButton!
    //text field delegaet
    let textFieldDelegate = TextFieldDelegate()
    //variable used for shifting keyboard
    var keyboardShift:CGFloat = 0
    //struct for holding meme params
    struct Meme {
        var topText:String?
        var bottoomText:String?
        var originalImage:UIImage?
        var memedImage:UIImage?
    }
    //instantiate meme class variable
    var meme = Meme()
    //text fields attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // configure UI elements
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        //subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //unsubscribe to keyboard notifications
        unsubscribeToKeyboardNotifications()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //show image picker controller
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
    func configureUI(){
        //configure UI
        activityButton.isEnabled = false //disable activity button at start
        //remove border
        topField.borderStyle = .none
        bottomField.borderStyle = .none
        //set text
        topField.text = "TOP"
        bottomField.text = "BOTTOM"
        //set text field attributes
        topField.defaultTextAttributes = memeTextAttributes
        bottomField.defaultTextAttributes = memeTextAttributes
        //set delegates
        topField.delegate = textFieldDelegate
        bottomField.delegate = textFieldDelegate
        if(!UIImagePickerController.isSourceTypeAvailable(.camera)){
            //if camera is not available disable button
            cameraButton.isEnabled = false
        }
    }
    //pick image from album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        activityButton.isEnabled = true
    }
    //capture image from camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        activityButton.isEnabled = true
    }
    //if keyboard will for bottom text field calculate shift
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomField.isFirstResponder{
            view.frame.origin.y -=  getKeyboardHeight(notification)
            self.keyboardShift = view.frame.origin.y
        }
    }
    //if keyboard will hide check if it's shifted unshift it
    @objc func keyboardWillHide(_ notification:Notification) {
        if self.keyboardShift != CGFloat(0) {
            view.frame.origin.y -= self.keyboardShift
            self.keyboardShift = 0
        }
    }
    //calculate height of keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    //subscribe to keyboard will show and hide notifs.
    func subscribeToKeyboardNotifications() {
       NotificationCenter.default.addObserver(self, selector:   #selector(keyboardWillShow(_:)), name:   UIResponder.keyboardWillShowNotification, object: nil)
       
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //unsubscribe from keyboard notifs
    func unsubscribeToKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //share meme
    @IBAction func shareMeme(_ sender: Any) {
        //generate image
        let img = generateMemedImage()
        //update meme struct data
        self.meme.memedImage = img
        self.meme.originalImage = self.imagePickerView.image
        self.meme.bottoomText = self.bottomField.text
        self.meme.topText = self.topField.text
        //show activity view controller
        let viewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        viewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                // User canceled
                viewController.dismiss(animated: true, completion: nil)
                return
            }
            // User completed activity
            self.save()
            viewController.dismiss(animated: true, completion: nil)
        }
        present(viewController, animated: true, completion: nil)
    }
    func save(){
        // save meme
        UIImageWriteToSavedPhotosAlbum(meme.memedImage!, nil, nil, nil)
    }
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //make a cropping rectangle
        let croppingRect = CGRect(x: 30, y: 115, width: memedImage.size.width - CGFloat(80), height: memedImage.size.height - CGFloat(250))
        //crop image based on rectangle
        let croppedImage = memedImage.cgImage!.cropping(to: croppingRect)
        UIGraphicsEndImageContext()
        return UIImage(cgImage: croppedImage!)
    }
}

