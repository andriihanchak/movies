//
//  AppContext.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

final class AppContext {
    
    static private let apiKey: String = "a1e056dea0a509bddb7fe240ec34b26f"
    
    var movieInfoService: MovieInfoService { movieService }
    var popularMoviesService: PopularMoviesService { movieService }

    let networkReachibilityService: NetworkReachbilityService = AlamofireNetworkReachibilityService()
    let posterService: PosterService = TMDBPosterService()
    let trailerService: TrailerService = XCDYouTubeService()
    
    private let movieService: TMDBMovieService = TMDBMovieService(apiKey: apiKey)
    
    private(set) lazy var snackbarController: SnackbarController = SnackbarController(networkReachabilityService: networkReachibilityService)
}
