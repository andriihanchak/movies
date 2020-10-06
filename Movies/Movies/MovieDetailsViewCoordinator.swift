//
//  MovieDetailsViewCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

final class MovieDetailsViewCoordinator: Coordinator {
    
    private let appContext: AppContext
    private let movie: Movie
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, movie: Movie, appContext: AppContext) {
        self.appContext = appContext
        self.movie = movie
        self.navigationController = navigationController
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.defaultStoryboardIdentifier) as? MovieDetailsViewController
        else { return }
        
        let viewModel = MovieDetailsViewModel(movie: movie, movieService: appContext.tmdbMovieService, posterService: appContext.tmdbPosterService)
        
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    override func finish() {
        navigationController.popViewController(animated: true)
        delegate?.finish(self)
    }
}
