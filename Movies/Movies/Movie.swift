//
//  Movie.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Foundation

struct Movie: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case date = "release_date"
        case id
        case genres
        case overview
        case posterPath = "backdrop_path"
        case title
        
    }
    
    let date: String
    let id: Int
    let genres: [MovieGenre]
    let overview: String
    let posterPath: String?
    let title: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(String.self, forKey: .date)
        id = try container.decode(Int.self, forKey: .id)
        genres = try container.decodeIfPresent([MovieGenre].self, forKey: .genres) ?? []
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        title = try container.decode(String.self, forKey: .title)
    }
}
