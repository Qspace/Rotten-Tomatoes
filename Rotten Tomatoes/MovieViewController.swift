//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by MAC on 11/9/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftLoader

var rowSelectIndex: Int = -1

var movies = [NSDictionary]()

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  //Use refresh scroll for table View
  var refreshControl: UIRefreshControl!
  
  @IBOutlet var tableView: UITableView!
  
  let dataURL = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214"
  
  
  @IBOutlet var networkLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    networkLabel.hidden = true
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)

    // Cofig and show Swifloader, SwiftLoader will Hide after fetchMovies task complete
    var config : SwiftLoader.Config = SwiftLoader.Config()
    config.size = 150
    config.spinnerColor = .redColor()
    config.foregroundColor = .blackColor()
    config.foregroundAlpha = 0.5
    SwiftLoader.setConfig(config)
    SwiftLoader.show(animated: true)
    
    // Network checking use Reachablity
    if Reachability.isConnectedToNetwork() == true {
      print("Internet connection OK")
    } else {
      print("Internet connection FAILED")
      networkLabel.text = "Network connection error"
      networkLabel.hidden = false
      SwiftLoader.hide()
    }
    
    fetchMovies(dataURL)
    
    
  }
  
  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
  
  func onRefresh() {
    delay(2, closure: {
      self.refreshControl.endRefreshing()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieCell
    cell.titleLabel.text = movies[indexPath.row]["title"] as? String
    cell.synopsisLabel.text = movies[indexPath.row]["synopsis"] as? String
    // set poster image with URLImage
    if let posterDict = movies[indexPath.row]["posters"] as? NSDictionary {
      let imageUrlStr = posterDict["thumbnail"] as! String
      let imageUrl = NSURL(string: imageUrlStr)
      
      print("image: ",imageUrl)

      cell.posterImageView.setImageWithURL(imageUrl!)
    }

    // insert image from Network AFN networking
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    rowSelectIndex = indexPath.row
  }
  
  func fetchMovies(urlString: String) {
    
    let url = NSURL(string: urlString)
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      guard error == nil else  {
        print("error loading from URL", error!)
        return
      }
      
      let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
      
      movies = json["movies"] as! [NSDictionary]
//      print("movies", self.movies)
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.tableView.reloadData()
        SwiftLoader.hide()
      })
    }
    task.resume()

  }
}