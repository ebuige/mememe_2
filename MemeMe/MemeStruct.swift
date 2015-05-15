//
//  MemeStruct.swift
//  MemeMe
//
//  Created by Troutslayer33 on 5/10/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//
// Struct to hold memes data


import UIKit
struct Meme {
    var textFieldTop: String?
    var textFieldBottom: String?
    var image: UIImage
    var memeImage: UIImage
    
         init (textFieldTop: String, textFieldBottom: String, image: UIImage, memeImage: UIImage){
              self.textFieldTop = textFieldTop
              self.textFieldBottom = textFieldBottom
              self.image = image
              self.memeImage = memeImage
        }
}
