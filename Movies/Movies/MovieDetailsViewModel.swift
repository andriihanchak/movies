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
    
    var items: Observable<[MovieDetailsViewItem]> { movie.map { self.createItems(from: $0) } }
    var title: Observable<String> { .just("Movie Details") }
    
    static private let dateFormatter = DateFormatter()
    
    private let disposeBag = DisposeBag()
    private let movie: BehaviorRelay<Movie>
    private let trailerURL: BehaviorRelay<URL?> = .init(value: nil)
    
    private let movieService: MovieService
    private let posterService: PosterService
    
    init(movie: Movie, movieService: MovieService, posterService: PosterService) {
        self.movie = .init(value: movie)
        self.movieService = movieService
        self.posterService = posterService
    }
    
    func loadDetails() {
        let getMovieDetails = movieService.getMovieDetails(movie.value)
        let getMovieVideos = movieService.getMovieVideos(movie.value)
        
        Observable.combineLatest(getMovieDetails, getMovieVideos)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe { [weak self] (movie, videos) in self?.updateMovie(update: movie, videos: videos) }
            .disposed(by: disposeBag)
    }
    
    func watchTrailer() {
        
    }
    
    private func updateMovie(update: Movie, videos: [MovieVideo]) {
        movie.accept(update)
        
        if let video = videos.first {
            let url = URL(string: "https://www.youtube.com/watch?v=\(video.key)")
            
            trailerURL.accept(url)
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
