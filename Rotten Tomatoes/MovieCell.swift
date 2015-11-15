//
//  MovieCell.swift
//  Rotten Tomatoes
//
//  Created by MAC on 11/9/15.
//  Copyright © 2015 MAC. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  
  
  @IBOutlet var titleLabel: UILabel!

  @IBOutlet var synopsisLabel: UILabel!
  
  @IBOutlet var posterImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
