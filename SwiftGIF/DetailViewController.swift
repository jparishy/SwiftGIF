//
//  DetailViewController.swift
//  SwiftGIF
//
//  Created by Julius Parishy on 6/2/14.
//  Copyright (c) 2014 jp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var webView: UIWebView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        
        if !self.webView {
            return
        }
        
        let request = NSURLRequest(URL: self.detailItem as NSURL)
        self.webView.loadRequest(request)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

