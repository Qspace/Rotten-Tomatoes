//
//  DvdViewController.swift
//  Rotten Tomatoes
//
//  Created by MAC on 11/14/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit

class DvdViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate {
  let dvdUrlStr = "https://coderschool-movies.herokuapp.com/dvds?api_key=xja087zcvxljadsflh214"
  var dvdMovies = [NSDictionary] ()
  @IBOutlet var DvdCollectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "DVD"
    fetchMovies(dvdUrlStr)
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dvdMovies.count
  }
  
  // make a cell for each cell index path
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    // get a reference to our storyboard cell
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dvdCell", forIndexPath: indexPath) as! DvdCollectionViewCell
    cell.dvdMovieTitle.text = dvdMovies[indexPath.row]["title"] as? String
    
    let dvdPoster = dvdMovies[indexPath.row]["posters"] as! NSDictionary
    let dvdImageStr = dvdPoster["thumbnail"] as! String
    let dvdImageUrl = NSURL(string: dvdImageStr)
    print("dcd Image: ",dvdImageUrl)
    cell.dvdMovieImage.setImageWithURL(dvdImageUrl!)
    
    
    // Use the outlet in our custom class to get a reference to the UILabel in the cell
//    cell.myLabel.text = self.items[indexPath.item]
    cell.backgroundColor = UIColor.brownColor() // make cell more visible in our example project
    
    return cell
  }
  
  // MARK: - UICollectionViewDelegate protocol
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    // handle tap events
    print("You selected cell #\(indexPath.item)!")
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
      
      self.dvdMovies = json["movies"] as! [NSDictionary]
      //      print("movies", self.movies)
      
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.DvdCollectionView.reloadData()
      })
    }
    task.resume()
    
  }

  
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
