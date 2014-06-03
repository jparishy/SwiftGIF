//
//  GIFCell.swift
//  SwiftGIF
//
//  Created by Julius Parishy on 6/3/14.
//  Copyright (c) 2014 jp. All rights reserved.
//

import UIKit

class GIFCell: UITableViewCell {
    
    var dataTask: NSURLSessionDataTask!
    
    @IBOutlet var gifImageView: UIImageView!
    
    var url: NSURL! {
    
        didSet {
        
            self.gifImageView.image = nil
            
            if self.dataTask {
                if self.dataTask.originalRequest.URL != self.url {
                    self.dataTask.cancel()
                }
            }
            
            self.dataTask = NSURLSession.sharedSession().dataTaskWithURL(self.url) {
                (data, response, error) in
                
                if error {
                    return
                }
                
                let image: UIImage = UIImage(data: data)
                
                dispatch_async(dispatch_get_main_queue()) {
                
                    self.gifImageView.image = image
                }
            }
            
            self.dataTask.resume()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        self.gifImageView.image = nil
    }
}
