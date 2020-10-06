//
//  MovieDetailsViewCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

final class MovieDetailsViewCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let movie: Movie
    private let movieService: MovieService
    private let posterService: PosterService
    
    init(navigationController: UINavigationController, movie: Movie, movieService: MovieService, posterService: PosterService) {
        self.navigationController = navigationController
        self.movie = movie
        self.movieService = movieService
        self.posterService = posterService
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.defaultStoryboardIdentifier) as? MovieDetailsViewController
        else { return }
        
        let viewModel = MovieDetailsViewModel(movie: movie, movieService: movieService, posterService: posterService)
        
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    override func finish() {
        navigationController.popViewController(animated: true)
        delegate?.finish(self)
    }
}
