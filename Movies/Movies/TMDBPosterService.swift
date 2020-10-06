//
//  TMDBPosterService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

final class TMDBPosterService: PosterService {
    
    private let baseURL = URL(string: "https://image.tmdb.org")!
    
    func getMoviePosterURL(_ movie: Movie, size: PosterSize) -> URL {
        return baseURL.appendingPathComponent("/t/p/\(size.rawValue)\(movie.posterPath)")
    }
}
