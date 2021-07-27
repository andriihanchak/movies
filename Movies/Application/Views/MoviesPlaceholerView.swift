//
//  MoviesPlaceholerView.swift
//  Movies
//
//  Created by Andrii Hanchak on 07.10.2020.
//

import UIKit

final class MoviesPlaceholderView: UIView {
    
    @IBOutlet private weak var label: UILabel!
    
    func configure(with text: String) {
        label.text = text
    }
}
