//
//  MoviesViewCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import RxSwift
import UIKit

final class MoviesViewCoordinator: Coordinator<Void> {
    
    private let appContext: AppContext
    private let disposeBag: DisposeBag = DisposeBag()
    private var window: UIWindow { appContext.window }
    
    init(appContext: AppContext) {
        self.appContext = appContext
    }
    
    override func start() -> Observable<Void> {
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
            .flatMap { [unowned self] (movie) in self.showMovieDetailsView(for: movie)  }
            .subscribe()
            .disposed(by: disposeBag)
            
        viewController?.viewModel = viewModel
        
        window.rootViewController = navigationController
        
        return viewModel.onDeinitialize
            .do(onCompleted: { [weak self] in self?.window.rootViewController = nil })
            .asObservable()
    }
    
    private func showMovieDetailsView(for movie: Movie) -> Observable<Void> {
        guard let navigationController = window.rootViewController as? UINavigationController
        else { return Observable.empty().asObservable() }
        
        let coordinator = MovieDetailsViewCoordinator(navigationController: navigationController, movie: movie, appContext: appContext)
        
        return start(coordinator)
    }
}
