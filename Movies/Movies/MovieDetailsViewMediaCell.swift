//
//  MovieDetailsViewMediaCell.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

final class MovieDetailsViewMediaCell: UITableViewCell {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var watchTrailerButton: UIButton!
    
    func configure(with item: MovieDetailsViewMediaItem) {
        movieImageView.image = UIImage(named: item.imageName)
        movieTitleLabel.text = item.title
        watchTrailerButton.setTitle(item.action, for: .normal)
    }
    
    @IBAction private func watchTrailer(_ sender: UIButton) {
        
    }
}
