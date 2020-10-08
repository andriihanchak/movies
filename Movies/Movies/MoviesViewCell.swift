//
//  MoviesViewCell.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import SDWebImage
import UIKit

final class MoviesViewCell: UITableViewCell {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.image = placeholderImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        sd_cancelCurrentImageLoad()
        
        movieImageView.image = placeholderImage()
    }
    
    func configure(with item: MoviesViewItem) {
        movieImageView?.sd_setImage(with: item.posterURL, placeholderImage: placeholderImage())
        movieTitle.text = item.title
        
    }
    
    private func placeholderImage() -> UIImage? { UIImage(named: "MoviesPlaceholder") }
}
