//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Troutslayer33 on 5/10/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Hide the tab bar and set the image
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.imageView!.image = meme.memeImage
    }
    
    // show tab bar when view disappears
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}

