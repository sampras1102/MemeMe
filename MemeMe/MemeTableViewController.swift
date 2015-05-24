//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/20/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class SavedMemesTableViewController: UIViewControllerWithCenterInstructionLabel, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionLabel = CenteredInstructionUILabel(superview: view, text: "Press the + button to add a meme")
    }
    
    override func hideInstructionLabel() -> Bool {
        return !(memes == nil || memes.count == 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes //this needs to be the first thing that happens
        tableViewOutlet.hidden = (memes?.count == 0)
        tabBarController?.tabBar.hidden = false
        tableViewOutlet.reloadData()
        
        super.viewWillAppear(animated) //need to call this after memes variable gets updated
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topString + " " + meme.bottomString
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will display the text
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomString
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.index = indexPath.row
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let editController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! ViewController
        presentViewController(editController, animated: true, completion: nil)
    }
}
