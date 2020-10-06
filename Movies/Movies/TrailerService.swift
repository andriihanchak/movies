//
//  TrailerService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation
import RxSwift

protocol TrailerService {
    
    func getMovieTrailerURL(_ movieVideo: MovieVideo) -> Observable<URL?>
}
