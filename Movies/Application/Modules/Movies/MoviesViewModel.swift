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
    
    var isLoading: Observable<Bool> { loading.asObservable() }
    
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
    
    var onShowMovieDetailsView: Observable<Movie> { showMovieDetailsView.compactMap{ $0 }  }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var filter: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    private let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    private var page: Int = 1
    private let showMovieDetailsView: BehaviorRelay<Movie?> = BehaviorRelay(value: nil)
    
    private let errorController: ErrorControllerType
    private let movieService: PopularMoviesService
    private let posterService: PosterService
    
    init(movieService: PopularMoviesService, posterService: PosterService, errorController: ErrorControllerType) {
        self.errorController = errorController
        self.movieService = movieService
        self.posterService = posterService
    }
    
    func filter(with criteria: String?) {
        filter.accept(criteria)
    }
    
    func load(fromBeginning: Bool) {
        guard filter.value?.isEmpty == true
        else { return }
        
        if fromBeginning {
            loading.accept(true)
            page = 1
            movies.accept([])
        }
        
        movieService.getPopularMovies(page: page)
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] (popularMovies) in
                guard let self = self else { return }
                self.movies.accept(self.movies.value + popularMovies.results)
                self.page = popularMovies.page + 1
            }, onError: { [weak self] (error) in
                self?.loading.accept(false)
                self?.errorController.showError(error)
            }, onCompleted: { [weak self] in
                self?.loading.accept(false)
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
