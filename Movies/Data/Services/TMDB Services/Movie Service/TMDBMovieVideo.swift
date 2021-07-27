//
//  TMDBResponse.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

struct TMDBMovieVideo: Decodable {
    
    let id: Int
    let results: [MovieVideo]
}
