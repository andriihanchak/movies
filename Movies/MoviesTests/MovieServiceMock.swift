//
//  MovieServiceMock.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 08.10.2020.
//

import Foundation
import RxSwift

@testable import Movies

class MovieServiceMock: MovieService {
    
    var error: Error!
    var movie: Movie!
    var movieVideos: [MovieVideo]!
    var popularMovie: TMDBPopularMovie!
    
    func getMovieDetails(_ movie: Movie) -> Observable<Movie> {
        return error != nil ? .error(error) : .just(movie)
    }
    
    func getMovieVideos(_ movie: Movie) -> Observable<[MovieVideo]> {
        return error != nil ? .error(error) : .just(movieVideos)
    }
    
    func getPopularMovies(page: Int) -> Observable<TMDBPopularMovie> {
        return error != nil ? .error(error) : .just(popularMovie)
    }
}
