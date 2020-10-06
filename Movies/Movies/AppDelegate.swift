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
    private let tmdbPosterService = TMDBPosterService(apiKey: apiKey)
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}
