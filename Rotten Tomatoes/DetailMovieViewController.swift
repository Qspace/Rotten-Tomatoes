//
//  DetailMovieViewController.swift
//  Rotten Tomatoes
//
//  Created by MAC on 11/13/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit
import SwiftLoader

class DetailMovieViewController: UIViewController {
  
  @IBOutlet var movieImageView: UIImageView!
  
  @IBOutlet var scrollView: UIScrollView!
  
  @IBOutlet var detailMovieView: UIView!
  
  
  @IBOutlet var scoreLabel: UILabel!
  
  @IBOutlet var DetailMovieSynopsisLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //Config Swiftloader and show
    var config : SwiftLoader.Config = SwiftLoader.Config()
    config.size = 150
    config.spinnerColor = .redColor()
    config.foregroundColor = .blackColor()
    config.foregroundAlpha = 0.5
    SwiftLoader.setConfig(config)
    SwiftLoader.show(animated: true)
    
    movieImageView.alpha = 0
    
    self.scrollView.alpha = 0.7
    self.scrollView.backgroundColor = UIColor.clearColor()
  
    self.detailMovieView.backgroundColor = UIColor.blackColor()
    
    
    scoreLabel.textColor = UIColor.whiteColor()
    DetailMovieSynopsisLabel.textColor = UIColor.whiteColor()
    
    // Show the information about the movie select
    var movieSelectDict = NSDictionary()
    if searchActive == false {
      movieSelectDict = movies[rowSelectIndex]
    }
    else {
      movieSelectDict = filterMovies[rowSelectIndex]
    }
    if movieSelectDict["title"] != nil {
      title = movieSelectDict["title"] as! String
      let ratings =  movieSelectDict["ratings"] as! NSDictionary
      let critics_score = ratings["critics_score"]!
      let audience_score = ratings["audience_score"]!
      scoreLabel.text = "Critic score: \(critics_score) ; Audience score: \(audience_score)"
      
      
      DetailMovieSynopsisLabel.text = movieSelectDict["synopsis"] as! String
      let detailPosterDict = movieSelectDict["posters"] as! NSDictionary
      let detailImgStr = detailPosterDict["detailed"] as! String
      let url = NSURL(string: detailImgStr)
      
      movieImageView.setImageWithURL(url!)
      fadeInImage()
      
      self.detailMovieView.frame = CGRectMake(CGRectGetMinX(self.detailMovieView.frame), CGRectGetMinY(self.detailMovieView.frame), CGRectGetWidth(self.detailMovieView.frame), CGRectGetMaxY(self.DetailMovieSynopsisLabel.frame))
      
      self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetMaxY(self.DetailMovieSynopsisLabel.frame))
      
      SwiftLoader.hide()
    }
    
    
    // Do any additional setup after loading the view.
  }
  
  func fadeInImage() {
    UIView.beginAnimations("fade in", context: nil)
    UIView.setAnimationDuration(1.5)
    self.movieImageView.alpha = 1
    UIView.commitAnimations()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
