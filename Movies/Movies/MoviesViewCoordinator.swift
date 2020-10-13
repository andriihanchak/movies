//
//  MoviesViewCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import RxSwift
import UIKit

final class MoviesViewCoordinator: Coordinator {
    
    private let appContext: AppContext
    private let disposeBag: DisposeBag = DisposeBag()
    private var window: UIWindow?
    
    init(window: UIWindow?, appContext: AppContext) {
        self.appContext = appContext
        self.window = window
    }
    
    override func start() {
        let errorController = ErrorController()
        let viewModel = MoviesViewModel(movieService: appContext.popularMoviesService,
                                        posterService: appContext.posterService,
                                        errorController: errorController)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let viewController = navigationController?.topViewController as? MoviesViewController
        
        errorController.onShowError
            .subscribe(onNext: { [weak self] (message) in self?.appContext.snackbarController.showMessage(message) })
            .disposed(by: disposeBag)
        
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
        
        let coordinator = MovieDetailsViewCoordinator(navigationController: navigationController, movie: movie, appContext: appContext)
        
        start(coordination: coordinator)
    }
}
