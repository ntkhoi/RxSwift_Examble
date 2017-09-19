//
//  MovieCell.swift
//  MovieRxSwift
//
//  Created by Khoi Nguyen on 9/18/17.
//  Copyright © 2017 Khoi Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie?{
        didSet{
            guard let movie = movie  else { return }
            titleLabel.text = movie.title
            overviewLabel.text = movie.overview
            if let posterUrl = movie.posterUrl {
                posterImageView.sd_setImage(with: posterUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


