//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/20/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
        
    @IBAction func addMeme(sender: AnyObject) {
        
        println("pushed the button")
        
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! ViewController
        self.presentViewController(editController, animated: true, completion: nil)
    }
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.tabBarController?.tabBar.hidden = false

    }
        // MARK: Table View Data Source
    
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.memes.count
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
            let meme = self.memes[indexPath.row]
            
            // Set the name and image
            cell.memeImageView?.image = meme.memedImage
            
            return cell
        }
        
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
        {
            
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
            detailController.meme = self.memes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
            
        }
        
}