//
//  PopularMoviesService.swift
//  Movies
//
//  Created by Andrii Hanchak on 13.10.2020.
//

import Foundation
import RxSwift

protocol PopularMoviesService {
    
    func getPopularMovies(page: Int) -> Observable<TMDBPopularMovie>
}
