//
//  MovieDetailsViewMediaItem.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

struct MovieDetailsViewMediaItem: MovieDetailsViewItem {
    
    let action: String
    let actionEnabled: Bool
    let posterURL: URL?
    let title: String
}
