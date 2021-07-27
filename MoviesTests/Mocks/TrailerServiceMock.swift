//
//  TrailerServiceMock.swift
//  MoviesTests
//ovi
//  Created by Andrii Hanchak on 08.10.2020.
//

import Foundation
import RxSwift

@testable import Movies

class TrailerServiceMock: TrailerService {
    
    var movieVideo: MovieVideo!
    
    func getMovieTrailerURL(_ movieVideo: MovieVideo) -> Observable<URL?> {
        let url = URL(string: "https://youtube.com/v/")?.appendingPathComponent(movieVideo.key)
        return .just(url)
    }
}
