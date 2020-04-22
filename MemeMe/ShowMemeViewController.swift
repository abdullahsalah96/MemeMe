//
//  ShowMemeViewController.swift
//  MemeMe
//
//  Created by Abdalla Elshikh on 4/22/20.
//  Copyright © 2020 Abdalla Elshikh. All rights reserved.
//

import UIKit

class ShowMemeViewController: UIViewController {
    
    var image:UIImage?
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let img = self.image{
            self.memeImage.image = img
        }
    }
}
