//
//  MovieDetailsViewCoordinator.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import AVKit
import RxSwift
import UIKit

final class MovieDetailsViewCoordinator: Coordinator {
    
    private let appContext: AppContext
    private let disposeBag = DisposeBag()
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
        
        let viewModel = MovieDetailsViewModel(movie: movie, movieService: appContext.tmdbMovieService, posterService: appContext.tmdbPosterService, trailerService: appContext.xcdYoutubeService)
        
        viewController.viewModel = viewModel
        
        viewModel.onDeinitialize
            .skip(1)
            .subscribe(onNext: { [weak self] in self?.finish() })
            .disposed(by: disposeBag)
        
        viewModel.onShowPlayerView
            .subscribe(onNext: { [weak self] (url) in
                        self?.showPlayerView(with: url) })
            .disposed(by: disposeBag)
                
                       
        navigationController.pushViewController(viewController, animated: true)
    }
    
    override func finish() {
        navigationController.popViewController(animated: true)
        delegate?.finish(self)
    }
    
    private func showPlayerView(with url: URL) {
        let playerViewController = AVPlayerViewController()
        let player = AVPlayer(url: url)
        
        if #available(iOS 11.0, *) {
            playerViewController.entersFullScreenWhenPlaybackBegins = true
        }
        
        playerViewController.player = player
        
        navigationController.topViewController?.present(playerViewController, animated: true) {
            player.play()
        }
    }
}
