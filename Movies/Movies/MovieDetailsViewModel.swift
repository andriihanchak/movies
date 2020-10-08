//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxRelay
import RxSwift

final class MovieDetailsViewModel: MovieDetailsViewModelType {
    
    var isLoading: Observable<Bool> { loading.asObservable() }
    
    var items: Observable<[MovieDetailsViewItem]> {
        return Observable.combineLatest(movie, trailerURL).map { self.createItems(from: $0.0) }
    }
    
    var title: Observable<String> { .just("Movie Details") }
    
    var onDeinitialize: Observable<Void> { deinitialize.asObservable() }
    var onShowErrorView: Observable<String> {  showErrorView.compactMap { $0 } }
    var onShowPlayerView: Observable<URL> { showPlayerView.compactMap { $0 } }
    
    static private let dateFormatter: DateFormatter = DateFormatter()
    
    private let deinitialize: BehaviorRelay<Void> = BehaviorRelay(value: ())
    private let disposeBag: DisposeBag = DisposeBag()
    private let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let movie: BehaviorRelay<Movie>
    private let showErrorView: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    private let showPlayerView: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    private let trailerURL: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    
    private let movieService: MovieService
    private let posterService: PosterService
    private let trailerService: TrailerService
    
    init(movie: Movie, movieService: MovieService, posterService: PosterService, trailerService: TrailerService) {
        self.movie = .init(value: movie)
        self.movieService = movieService
        self.posterService = posterService
        self.trailerService = trailerService
    }
    
    deinit {
        deinitialize.accept(())
    }
    
    func loadDetails() {
        let getMovieDetails = movieService.getMovieDetails(movie.value)
        let getMovieVideos = movieService.getMovieVideos(movie.value)
        
        loading.accept(true)
        
        Observable.combineLatest(getMovieDetails, getMovieVideos)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] (movie, videos) in self?.updateMovie(movie: movie, videos: videos) },
                       onError: { [weak self] (error) in
                        self?.loading.accept(false)
                        
                        switch error {
                        case Error.getMovieDetails(_):
                            self?.showErrorView.accept("Couldn't get some movie details. Please, try again.")
                            
                        case Error.getMovieVideos(_):
                            self?.trailerURL.accept(nil)
                            self?.showErrorView.accept("Couldn't get movie trailer. Please, try again.")
                            
                        case Error.notConnectedToInternet:
                            self?.showErrorView.accept("No network connection. Please, try again.")
                            
                        default:
                            self?.showErrorView.accept("Something went wrong. Please, try again.")
                        }
                       }, onCompleted: { [weak self] in self?.loading.accept(false) })
            .disposed(by: disposeBag)
    }
    
    func watchTrailer() {
        showPlayerView.accept(trailerURL.value)
    }
    
    private func updateMovie(movie: Movie, videos: [MovieVideo]) {
        self.movie.accept(movie)
        
        if let video = videos.first {
            trailerService.getMovieTrailerURL(video)
                .bind(to: trailerURL)
                .disposed(by: disposeBag)
        }
    }
    
    private func createItems(from movie: Movie) -> [MovieDetailsViewItem] {
        let action = "Watch Trailer"
        let actionEnabled = trailerURL.value != nil
        let dateFormatter = Self.dateFormatter
        let genres = movie.genres.compactMap { $0.name }.joined(separator: ",")
        let url = posterService.getMoviePosterURL(movie, size: .movieDetails)
        
        var items: [MovieDetailsViewItem] = []
        
        items.append(MovieDetailsViewMediaItem(action: action, actionEnabled: actionEnabled, posterURL: url, title: movie.title))
        
        if !genres.isEmpty {
            items.append(MovieDetailsViewTextItem(title: "Genre", details: genres))
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: movie.date) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            items.append(MovieDetailsViewTextItem(title: "Date", details: dateFormatter.string(from: date)))
        }
        
        if !movie.overview.isEmpty {
            items.append(MovieDetailsViewTextItem(title: "Overview", details: movie.overview))
        }
        
        return items
    }
}
