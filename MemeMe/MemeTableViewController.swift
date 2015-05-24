//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Chris Supranowitz on 5/20/15.
//  Copyright (c) 2015 Chris Supranowitz. All rights reserved.
//

import UIKit

class SavedMemesTableViewController: UIViewControllerWithCenterInstructionLabel, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func addMeme(sender: AnyObject) {
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewController") as! ViewController
        self.presentViewController(editController, animated: true, completion: nil)
    }
    @IBOutlet weak var tableViewOutlet: UITableView!

    // MARK: Table View Data Source
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionLabel = CenteredInstructionUILabel(superview: self.view, text: "Press the + button to add a meme")
        self.tableViewOutlet.contentInset = UIEdgeInsetsMake(0,0,0,0)
    }
    
    override func hideInstructionLabel() -> Bool {
        return !(memes == nil || memes.count == 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes //this needs to be the first thing that happens
        if let m = memes{
            tableViewOutlet.hidden = (m.count == 0)
        }
        self.tabBarController?.tabBar.hidden = false
        tableViewOutlet.reloadData()
        
        super.viewWillAppear(animated) //need to call this after memes variable gets updated
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topString + " " + meme.bottomString
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will display the text
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomString
        }
        
        println("\(cell.imageView?.frame)")
        
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        detailController.existingIndex = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
        
}
