//
//  AppContext.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

final class AppContext {
    
    static private let apiKey: String = "a1e056dea0a509bddb7fe240ec34b26f"
    
    let tmdbMovieService = TMDBMovieService(apiKey: apiKey)
    let tmdbPosterService = TMDBPosterService()
    let xcdYoutubeService = XCDYouTubeService()
}