//
//  MovieService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

protocol MovieService {
    
    func getMovieDetails(_ movie: Movie) -> Observable<Movie>
    func getMovieVideos(_ movie: Movie) -> Observable<[MovieVideo]>
    func getPopularMovies(page: Int) -> Observable<TMDBPopularMovie>
}
