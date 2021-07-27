//
//  TMDBPopularMovie.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

struct TMDBPopularMovie: Codable {
    
    let page: Int
    let results: [Movie]
}
