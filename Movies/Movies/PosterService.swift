//
//  ImageService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import UIKit

protocol PosterService {
    
    func getMoviePoster(_ movie: Movie, completion: @escaping (URL?) -> Void)
}
