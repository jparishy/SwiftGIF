//
//  MasterViewController.swift
//  SwiftGIF
//
//  Created by Julius Parishy on 6/2/14.
//  Copyright (c) 2014 jp. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchDisplayDelegate {

    var trending = Array<GIF>()
    var searchResults = Array<GIF>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight
        var nib = UINib(nibName: "GIFCell", bundle: nil)
        
        var register: (UITableView) -> () = {
            (tableView: UITableView) in
            tableView.registerNib(nib, forCellReuseIdentifier: "GIF")
        }
        
        register(tableView)
        register(searchDisplayController.searchResultsTableView)
        
        GIF.downloadTrending {
            (trending: Array<GIF>) in
            
            self.trending = trending
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // #pragma mark - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
        
            let tableView = sender as UITableView
            let indexPath = tableView.indexPathForSelectedRow()
            
            var gif: GIF
            
            if tableView == self.tableView {
                gif = self.trending[indexPath.row]
            } else {
                gif = self.searchResults[indexPath.row]
            }
        
            (segue.destinationViewController as DetailViewController).detailItem = gif.url
        }
    }

    // #pragma mark - Table View
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        self.performSegueWithIdentifier("showDetail", sender: tableView)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if tableView == self.tableView {
            return self.trending.count
        } else {
            return self.searchResults.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: GIFCell = tableView.dequeueReusableCellWithIdentifier("GIF", forIndexPath: indexPath) as GIFCell
        var gif: GIF
        
        if tableView == self.tableView {
            gif = self.trending[indexPath.row]
        } else {
            gif = self.searchResults[indexPath.row]
        }
        
        cell.url = gif.url
        
        return cell
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: NSString) -> Bool {
        
        GIF.downloadSearchResultsForText(searchString) {
            (searchResults: Array) in
            
            self.searchResults = searchResults
            self.searchDisplayController.searchResultsTableView.reloadData()
        }
        
        return true
    }
}

