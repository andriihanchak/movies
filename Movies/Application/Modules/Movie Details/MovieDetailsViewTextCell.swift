//
//  MovieDetailsViewTextCell.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

final class MovieDetailsViewTextCell: UITableViewCell {
    
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(with item: MovieDetailsViewTextItem) {
        detailsLabel.text = item.details
        titleLabel.text = item.title
    }
}
