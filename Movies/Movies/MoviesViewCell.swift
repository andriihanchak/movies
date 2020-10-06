//
//  MoviesViewCell.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

final class MoviesViewCell: UITableViewCell {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    
    func configure(with item: MoviesViewItem) {
        movieImageView.image = UIImage(named: item.imageName)
        movieTitle.text = item.title
    }
}
