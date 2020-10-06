//
//  AppDelegate.swift
//  Movies
//
//  Created by Andrii Hanchak on 05.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static private let apiKey: String = "a1e056dea0a509bddb7fe240ec34b26f"
    
    private let tmdbMovieService = TMDBMovieService(apiKey: apiKey)
    private let tmdbPosterService = TMDBPosterService()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let navigationController = window?.rootViewController as? UINavigationController,
           let viewController = navigationController.topViewController as? MoviesViewController {
            viewController.viewModel = MoviesViewModel(movieService: tmdbMovieService, posterService: tmdbPosterService)
        }
        
        return true
    }
}
