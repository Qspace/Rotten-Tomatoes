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
var searchActive : Bool = false

var movies = [NSDictionary]()
var filterMovies = [NSDictionary]()

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  //Use refresh scroll for table View
  var refreshControl: UIRefreshControl!
  
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet var movieSearchBar: UISearchBar!
  
  let dataURL = "https://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214"
  
  
  @IBOutlet var networkLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    movieSearchBar.delegate = self
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // custom network label
    networkLabel.hidden = true
    networkLabel.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
    networkLabel.alpha = 0
    networkLabel.textColor = UIColor.whiteColor()
    networkLabel.textAlignment = .Center
    networkLabel.text = "Network connection error"
    
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
    
    fetchMovies(dataURL)
    
    
  }
  
  func showNetworkErr() {
    print("Internet connection FAILED")
    networkLabel.hidden = false
    networkLabel.alpha = 0
    let offset = 3.0
    UIView.animateWithDuration(offset, animations: {
      self.networkLabel.alpha = 1
    })
    SwiftLoader.hide()

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
    SwiftLoader.show(animated: true)
    delay(2, closure: {
      self.refreshControl.endRefreshing()
      SwiftLoader.hide()
      self.fetchMovies(self.dataURL)
    })
  }
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchActive = true;
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchActive = false;
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    filterMovies.removeAll()
    if searchText.isEmpty == true {
      searchActive = false
      return
    }
    searchActive = true
    
    
    for (var i = 0; i < movies.count; i++) {
      let title =  movies[i]["title"] as! String
      if title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil {
        print(title)
        filterMovies.append(movies[i])
      }
    }
    if filterMovies.count > 0 {
      tableView.reloadData()
    }
//    filtered = data.filter({ (text) -> Bool in
//      let tmp: NSString = text
//      let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//      return range.location != NSNotFound
//    })
//    if(filtered.count == 0){
//      searchActive = false;
//    } else {
//      searchActive = true;
//    }
//    self.tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieCell
    var movie = NSDictionary()
    if searchActive == false {
      movie = movies[indexPath.row]
    }
    else {
      print(indexPath.row)
      movie = filterMovies[indexPath.row]
    }
    cell.titleLabel.text = movie["title"] as? String
    cell.synopsisLabel.text = movie["synopsis"] as? String
    // set poster image with URLImage
    if let posterDict = movie["posters"] as? NSDictionary {
      let imageUrlStr = posterDict["thumbnail"] as! String
      let imageUrl = NSURL(string: imageUrlStr)
      
//      print("image: ",imageUrl)

      cell.posterImageView.setImageWithURL(imageUrl!)
    }

    // insert image from Network AFN networking
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchActive == false {
    return movies.count
    }
    else {
      print("Filter count",filterMovies.count)
      return filterMovies.count
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    rowSelectIndex = indexPath.row
  }
  
  func fetchMovies(urlString: String) {
    print("MovieUrlString: ",urlString)
    let url = NSURL(string: urlString)
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      guard error == nil else  {
        print("error loading from URL", error!)
        // Network checking use Reachablity
        if Reachability.isConnectedToNetwork() == true {
          print("Internet connection OK")
        } else {
          self.showNetworkErr()
        }
        return
      }
      
      let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
      if searchActive == false {
        movies = json["movies"] as! [NSDictionary]
//      print("movies", self.movies)
      }
      else {
          filterMovies = json["movies"] as! [NSDictionary]
      }
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.tableView.reloadData()
        SwiftLoader.hide()
      })
    }
    task.resume()

  }
}