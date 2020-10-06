//
//  MoviesViewCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import RxSwift
import UIKit

final class MoviesViewCoordinator: Coordinator {
    
    private let disposeBag = DisposeBag()
    private let movieService: MovieService
    private let posterService: PosterService
    private var window: UIWindow?
    
    init(window: UIWindow?, movieService: MovieService, posterService: PosterService) {
        self.movieService = movieService
        self.posterService = posterService
        self.window = window
    }
    
    override func start() {
        let viewModel = MoviesViewModel(movieService: movieService, posterService: posterService)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let viewController = navigationController?.topViewController as? MoviesViewController
        
        viewModel.onShowMovieDetailsView
            .subscribe(onNext: { [weak self] (movie) in self?.showMovieDetailsView(for: movie) })
            .disposed(by: disposeBag)
            
        viewController?.viewModel = viewModel
        
        window?.rootViewController = navigationController
    }
    
    override func finish() {
        window?.rootViewController = nil
    }
    
    private func showMovieDetailsView(for movie: Movie) {
        guard let navigationController = window?.rootViewController as? UINavigationController
        else { return }
        
        let coordinator = MovieDetailsViewCoordinator(navigationController: navigationController, movie: movie, movieService: movieService, posterService: posterService)
        
        coordinator.start()
    }
}
