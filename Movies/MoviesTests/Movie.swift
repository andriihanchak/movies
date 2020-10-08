//
//  Movie.swift
//  MoviesTests
//
//  Created by Andrii Hanchak on 08.10.2020.
//

import Foundation

@testable import Movies

extension Movie {
    
    static func stubbed(title: String, overview: String = "Overview", date: String = "2020-01-01", posterPath: String? = nil) -> Movie {
        let movie: [String: Any?] = ["release_date": date,
                                     "id": Int.random(in: 0...1000),
                                     "genres": nil,
                                     "overview": overview,
                                     "backdrop_path": posterPath,
                                     "title": title]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: movie, options: .prettyPrinted)
            return try JSONDecoder().decode(Movie.self, from: data)
        } catch {
            fatalError(#function)
        }
    }
}
