//
//  MovieInfoService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

protocol MovieInfoService {
    
    func getMovieDetails(_ movie: MovieIdentifiable) -> Observable<Movie>
    func getMovieVideos(_ movie: MovieIdentifiable) -> Observable<[MovieVideo]>
    
}
