//
//  ImageService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

protocol PosterService {

    func getMoviePosterURL(_ movie: Movie, size: PosterSize) -> URL
}
