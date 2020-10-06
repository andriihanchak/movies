//
//  MovieDetailsViewMediaCell.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import SDWebImage
import UIKit

final class MovieDetailsViewMediaCell: UITableViewCell {
    
    typealias OnWatchTrailer = () -> Void
    
    var onWatchTrailer: OnWatchTrailer?
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var watchTrailerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.image = placeholderImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        sd_cancelCurrentImageLoad()
        
        movieImageView.image = placeholderImage()
    }
    
    func configure(with item: MovieDetailsViewMediaItem) {
        movieImageView?.sd_setImage(with: item.posterURL, placeholderImage: placeholderImage())
        movieTitleLabel.text = item.title
        watchTrailerButton.setTitle(item.action, for: .normal)
    }
    
    @IBAction private func watchTrailer(_ sender: UIButton) {
        onWatchTrailer?()
    }
    
    private func placeholderImage() -> UIImage? { UIImage(named: "MoviesPlaceholder") }
}
