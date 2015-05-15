//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Troutslayer33 on 5/10/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    
    // set up the shared model and reload the tableviews data
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
        
}
    // if no memes sent present the meme editor
    
    override func viewDidAppear(animated: Bool) {
        if self.memes.count == 0 {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
            presentViewController(vc, animated: true, completion: nil)
        }

    }
    
    // Returns count of Memes array
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // populates cells with the data from the Memes array
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        let meme = self.memes[indexPath.row]
        
        cell.memeImage.image = meme.memeImage
        cell.textFieldTop.text = meme.textFieldTop
        cell.textFieldBottom.text = meme.textFieldBottom
        
        return cell
    }
    
    // When user taps a cell the meme detail view controller is presented with selected image
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    // function displays the memeEditor when user taps "+"
    
    @IBAction func memeEditor(sender: UIBarButtonItem) {
       let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        presentViewController(vc, animated: true, completion: nil)
        
    }
}

