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
        Observable.combineLatest(movies, filter)
            .map { (movies, filter) -> [Movie] in
                guard let filter = filter, !filter.isEmpty
                else { return movies }
                return movies.filter { (movie) in movie.title.lowercased().contains(filter.lowercased()) } }
            .map { $0.compactMap { (movie) in self.createMovieViewItem(from: movie) } }
            .asObservable()
    }
    
    var title: Observable<String> { .just("Movies") }
    
    var onShowMovieDetailsView: Observable<Movie> { showMovieDetailsView.compactMap{ $0 }.asObservable()  }

    private let disposeBag = DisposeBag()
    private var filter: BehaviorRelay<String?> = .init(value: nil)
    private var movies: BehaviorRelay<[Movie]> = .init(value: [])
    private var page: Int = 1
    private let showMovieDetailsView: BehaviorRelay<Movie?> = .init(value: nil)
    
    private let movieService: MovieService
    private let posterService: PosterService
    
    init(movieService: MovieService, posterService: PosterService) {
        self.movieService = movieService
        self.posterService = posterService
    }
    
    func filter(with criteria: String?) {
        filter.accept(criteria)
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
        let movie = movies.value[index]
        
        showMovieDetailsView.accept(movie)
    }
    
    private func createMovieViewItem(from movie: Movie) -> MoviesViewItem {
        let url = posterService.getMoviePosterURL(movie, size: .movies)
        
        return .init(title: movie.title, posterURL: url)
    }
}
