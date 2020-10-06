//
//  MovieService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

protocol MovieService {
    
    func getMovieDetails(_ movie: Movie, completion: @escaping (Movie) -> Void)
    func getMovieVideo(_ movie: Movie, completion: @escaping ([MovieVideo]) -> Void)
    func getPopularMovies(completion: @escaping ([Movie]) -> Void)
}
