//
//  MovieService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

protocol MovieService {
    
    func getMovieDetails(_ movie: MovieIdentifiable) -> Observable<Movie>
    func getMovieVideos(_ movie: MovieIdentifiable) -> Observable<[MovieVideo]>
    func getPopularMovies(page: Int) -> Observable<TMDBPopularMovie>
}
