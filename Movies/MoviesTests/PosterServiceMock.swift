//
//  PosterServiceMock.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 08.10.2020.
//

import Foundation

@testable import Movies

class PosterServiceMock: PosterService {
    
    var url: URL?
    
    func getMoviePosterURL(_ movie: Movie, size: PosterSize) -> URL? {
        return url
    }
}
