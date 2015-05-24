//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/20/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewControllerWithCenterInstructionLabel, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionLabel = CenteredInstructionUILabel(superview: self.view, text: "Press the + button to add a meme")
    }
    
    override func hideInstructionLabel() -> Bool {
        return !(memes == nil || memes.count == 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes //this needs to happen first.  Call to super.viewWillAppear depends on knowing if there are memes
        
        self.collectionView.reloadData()
        self.tabBarController?.tabBar.hidden = false
        
        super.viewWillAppear(animated) //need to call this after memes variable gets updated
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var spacing = CGFloat(5.0)
        var nItemsAcross = 3
        var cellSize = (self.view.bounds.width - (CGFloat(nItemsAcross) + 1)*spacing)/CGFloat(nItemsAcross)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView.collectionViewLayout = layout
        self.collectionView.sendSubviewToBack(self.view)
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! ViewController
        self.presentViewController(editController, animated: true, completion: nil)
    }
    
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
        detailController.index = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
        
}