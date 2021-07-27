//
//  MovieDetailsViewCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import RxSwift
import UIKit

final class MovieDetailsViewCoordinator: Coordinator<Void> {
    
    private let appContext: AppContext
    private let disposeBag = DisposeBag()
    private let movie: Movie
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, movie: Movie, appContext: AppContext) {
        self.appContext = appContext
        self.movie = movie
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<Void> {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.defaultStoryboardIdentifier) as? MovieDetailsViewController
        else { return Observable.empty().asObservable() }
        
        let errorController = ErrorController()
        let viewModel = MovieDetailsViewModel(movie: movie, movieService: appContext.movieInfoService, posterService: appContext.posterService, trailerService: appContext.trailerService, errorController: errorController)
        
        errorController.onShowError
            .subscribe(onNext: { [weak self] (message) in self?.appContext.snackbarController.showMessage(message) })
            .disposed(by: disposeBag)
        
        viewModel.onShowPlayerView
            .flatMap { [unowned self] (url) in self.showPlayerView(with: url) }
            .subscribe()
            .disposed(by: disposeBag)
                
        viewController.viewModel = viewModel
                       
        navigationController.pushViewController(viewController, animated: true)
        
        return viewModel.onDeinitialize
            .asObservable()
    }
    
    private func showPlayerView(with url: URL) -> Observable<Void> {
        let coordinator = AVPlayerViewCoordinator(navigationController: navigationController, videoURL: url)
        
        return start(coordinator)
    }
}
