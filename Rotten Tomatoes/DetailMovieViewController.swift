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
    
    // Show the information about the movie select
    let movieSelectDict = movies[rowSelectIndex]
    if movieSelectDict["title"] != nil {
      title = movieSelectDict["title"] as! String
      
      DetailMovieSynopsisLabel.text = movieSelectDict["synopsis"] as! String
      let detailPosterDict = movieSelectDict["posters"] as! NSDictionary
      let detailImgStr = detailPosterDict["detailed"] as! String
      let url = NSURL(string: detailImgStr)
      movieImageView.setImageWithURL(url!)
      SwiftLoader.hide()
    }
    
    
    // Do any additional setup after loading the view.
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
