//
//  TMDBPosterService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

final class TMDBPosterService: PosterService {
    
    private let baseURL = URL(string: "https://image.tmdb.org")!
    
    func getMoviePosterURL(_ movie: Movie, size: PosterSize) -> URL? {
        guard let posterPath = movie.posterPath
        else { return nil }
        
        return baseURL.appendingPathComponent("/t/p/\(size.rawValue)\(posterPath)")
    }
}
