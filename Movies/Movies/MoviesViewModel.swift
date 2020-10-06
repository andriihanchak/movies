//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxRelay
import RxSwift

final class MoviesViewModel: MoviesViewModelType {
    
    var items: Observable<[MoviesViewItem]> {
        return movies.map { $0.compactMap { (movie) in self.createMovieViewItem(from: movie) } }
    }
    
    var title: Observable<String> { .just("Movies") }

    private let disposeBag = DisposeBag()
    private var movies: BehaviorRelay<[Movie]> = .init(value: [])
    private var page: Int = 1
    
    private let movieService: MovieService
    private let posterService: PosterService
    
    init(movieService: MovieService, posterService: PosterService) {
        self.movieService = movieService
        self.posterService = posterService
    }
    
    func load() {
        movieService.getPopularMovies(page: page)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] (popularMovies) in
                guard let self = self else { return }
                self.movies.accept(self.movies.value + popularMovies.results)
                self.page = popularMovies.page + 1
            }).disposed(by: disposeBag)
    }
    
    func showDetails(forItemAt index: Int) {
        
    }
    
    private func createMovieViewItem(from movie: Movie) -> MoviesViewItem {
        let url = posterService.getMoviePosterURL(movie, size: .movies)
        
        return .init(title: movie.title, posterURL: url)
    }
}
