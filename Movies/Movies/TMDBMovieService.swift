//
//  TMDBMovieService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Alamofire
import Foundation

final class TMDBMovieService {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

extension TMDBMovieService: MovieService {
    
    func getMovieDetails(_ movie: Movie, completion: @escaping (Movie) -> Void) {
        let request = AF.request(API.movieDetails(id: movie.id).url(),
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding(destination: .queryString))
        
        request.responseDecodable { (response: DataResponse<Movie, AFError>) in
            switch response.result {
            case .failure(_):
                completion(movie)
                
            case let .success(movie):
                completion(movie)
            }
        }
        
    }
    
    func getMovieVideo(_ movie: Movie, completion: @escaping ([MovieVideo]) -> Void) {
        let request = AF.request(API.movieVideo(id: movie.id).url(),
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding(destination: .queryString))
        
        request.responseDecodable { (response: DataResponse<TMDBMovieVideo, AFError>) in
            switch response.result{
            case .failure(_):
                completion([])
                
            case let .success(response):
                completion(response.results)
            }
        }
    }
    
    func getPopularMovies(completion: @escaping ([Movie]) -> Void) {
        let request = AF.request(API.popularMovies.url(),
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding(destination: .queryString))

        request.responseDecodable { (response: DataResponse<TMDBPopularMovie, AFError>) in
            switch response.result {
            case .failure(_):
                completion([])
                
            case let .success(popularMovies):
                completion(popularMovies.results)
            }
        }
    }
}

extension TMDBMovieService {
    
    private enum API {
        
        private static let baseURL: URL = URL(string: "https://api.themoviedb.org/3")!
        
        case movieDetails(id: Int)
        case movieVideo(id: Int)
        case popularMovies
        
        func url() -> URL {
            switch self {
            case .movieDetails(let id):
                return Self.baseURL.appendingPathComponent("/movie/\(id)")
                
            case .movieVideo(let id):
                return Self.baseURL.appendingPathComponent("/movie/\(id)/videos")
                
            case .popularMovies:
                return Self.baseURL.appendingPathComponent("/movie/popular")
            }
        }
    }
    
    private var parameters: [String: Any] {
        return ["api_key": apiKey]
    }
}
