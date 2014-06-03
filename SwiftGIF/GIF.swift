//
//  SearchResult.swift
//  SwiftGIF
//
//  Created by Julius Parishy on 6/2/14.
//  Copyright (c) 2014 jp. All rights reserved.
//

import Foundation
import UIKit

struct GIF {

    var url: NSURL
    
    init(dict: NSDictionary) {
        
        let images: NSDictionary = dict["images"] as NSDictionary
        let fixedHeight: NSDictionary = images["fixed_height"] as NSDictionary
        let path = fixedHeight["url"] as NSString
        
        url = NSURL.URLWithString(path)
    }
    
    static func fromJSONArray(JSONArray: NSArray) -> Array<GIF> {
        
        var results = Array<GIF>()
        
        for (result: AnyObject) in JSONArray {
            results.append(GIF(dict: result as NSDictionary))
        }
        
        return results.copy()
    }
    
    static func downloadTrending(completion: (Array<GIF>) -> ()) {
    
        let url = NSURL(string: "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC")
        
        self.JSONWithURL(url) {
            (responseDictionary: NSDictionary) in
            
            let JSONArray: NSArray = responseDictionary["data"] as NSArray
            completion(self.fromJSONArray(JSONArray))
        }
    }
    
    static func downloadSearchResultsForText(text: NSString, completion: (Array<GIF>) -> ()) {
        
        let escaped = text.stringByReplacingOccurrencesOfString(" ", withString: "+").stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let path = "http://api.giphy.com/v1/gifs/search?q=\(escaped)&api_key=dc6zaTOxFJmzC"
        let url = NSURL(string: path)
        
        self.JSONWithURL(url) {
            (responseDictionary: NSDictionary) in
            
            let JSONArray: NSArray = responseDictionary["data"] as NSArray
            completion(self.fromJSONArray(JSONArray))
        }
    }
    
    static func JSONWithURL(url: NSURL, completion: (NSDictionary) -> ()) {
    
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) in
            
            let responseDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
            completion(responseDictionary)
        }
    }
}
