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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
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
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
    func configureUI(){
        setActivityButtonsState(false)
        topField.borderStyle = .none
        topField.text = "TOP"
        topField.textColor = UIColor.white
        topField.defaultTextAttributes = memeTextAttributes
        topField.delegate = textFieldDelegate
        bottomField.borderStyle = .none
        bottomField.text = "BOTTOM"
        bottomField.textColor = UIColor.white
        bottomField.defaultTextAttributes = memeTextAttributes
        bottomField.delegate = textFieldDelegate
        if(!UIImagePickerController.isSourceTypeAvailable(.camera)){
                cameraButton.isEnabled = false
            }
    }
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        setActivityButtonsState(true)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        setActivityButtonsState(true)
    }
    
    func setActivityButtonsState(_ x:Bool){
        cancelButton.isEnabled = x
        activityButton.isEnabled = x
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomField.isFirstResponder{
            view.frame.origin.y -=  getKeyboardHeight(notification)
            self.keyboardShift = view.frame.origin.y
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        print("HIIDEE")
        print(self.keyboardShift)
        if self.keyboardShift != CGFloat(0) {
            print("Before \(view.frame.origin.y)")
            view.frame.origin.y -= self.keyboardShift
            print("After \(view.frame.origin.y)")
            self.keyboardShift = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
       NotificationCenter.default.addObserver(self, selector:   #selector(keyboardWillShow(_:)), name:   UIResponder.keyboardWillShowNotification, object: nil)
       
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeToKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        //activity view controller
        let img = generateMemedImage()
        let viewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        present(viewController, animated: true, completion: nil)
    }
    
    func save(){
        // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topField.text!, bottoomText: bottomField.text!, originalImage: imagePickerView.image, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        // Render view to an image

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //make a cropping rectangle
        let croppingRect = CGRect(x: 30, y: 110, width: memedImage.size.width - CGFloat(80), height: memedImage.size.height - CGFloat(250))
        //crop image based on rectangle
        let croppedImage = memedImage.cgImage!.cropping(to: croppingRect)
        UIGraphicsEndImageContext()
        return UIImage(cgImage: croppedImage!)
    }
    
  
    
}

