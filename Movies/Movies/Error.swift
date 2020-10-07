//
//  Error.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

enum Error: Swift.Error {
    
    case getMovieDetails(_ movie: Movie)
    case getMovieVideos(_ movie: Movie)
    case getPopularMovies
    case notConnectedToInternet
}
