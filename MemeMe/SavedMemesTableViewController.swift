//
//  SavedMemesTableViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/20/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

    class SavedMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
        // Get ahold of some villains, for the table
        // This is an array of Villain instances
        
        // MARK: Table View Data Source
        
        var memes: [Meme]!
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            memes = appDelegate.memes
        }
        
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return memes.count
        }
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
            let meme = self.memes[indexPath.row]
            
            // Set the name and image
            cell.textLabel?.text = meme.topString
            cell.imageView?.image = meme.memedImage
            
            // If the cell has a detail label, we will put the evil scheme in.
            if let detailTextLabel = cell.detailTextLabel {
                detailTextLabel.text = meme.bottomString
            }
            
            return cell
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
            detailController.meme = self.memes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
            
        }
        
}
