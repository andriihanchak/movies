//
//  TMDBMovieService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Alamofire
import Foundation
import RxSwift

final class TMDBMovieService: MovieInfoService, PopularMoviesService {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getMovieDetails(_ movie: MovieIdentifiable) -> Observable<Movie> {
        let parsedError = self.parseError(_:expected:)
        let request = AF.request(API.movieDetails(id: movie.id).url(),
                                 method: .get,
                                 parameters: defaultParameters(),
                                 encoding: URLEncoding(destination: .queryString))
        
        return Single<Movie>.create { (promise) -> Disposable in
            request.responseDecodable { (response: DataResponse<Movie, AFError>) in
                switch response.result {
                case let .failure(error):
                    promise(.failure(parsedError(error, .getMovieDetails)))
                    
                case let .success(movie):
                    promise(.success(movie))
                }
            }
            
            return Disposables.create { request.cancel() }
        }.asObservable()
    }
    
    func getMovieVideos(_ movie: MovieIdentifiable) -> Observable<[MovieVideo]> {
        let parsedError = self.parseError(_:expected:)
        let request = AF.request(API.movieVideo(id: movie.id).url(),
                                 method: .get,
                                 parameters: defaultParameters(),
                                 encoding: URLEncoding(destination: .queryString))
        
        return Single<[MovieVideo]>.create { (promise) -> Disposable in
            request.responseDecodable { (response: DataResponse<TMDBMovieVideo, AFError>) in
                switch response.result{
                case let .failure(error):
                    promise(.failure(parsedError(error, .getMovieVideos)))
                    
                case let .success(response):
                    promise(.success(response.results))
                }
            }
            
            return Disposables.create { request.cancel() }
        }.asObservable()
    }
    
    func getPopularMovies(page: Int) -> Observable<TMDBPopularMovie> {
        var parameters = defaultParameters()
        
        parameters["page"] = page
        
        let parsedError = self.parseError(_:expected:)
        let request = AF.request(API.popularMovies.url(),
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding(destination: .queryString))
        
        return Single<TMDBPopularMovie>.create { (promise) -> Disposable in
            request.responseDecodable { (response: DataResponse<TMDBPopularMovie, AFError>) in
                switch response.result {
                case let .failure(error):
                    promise(.failure(parsedError(error, .getPopularMovies)))
                    
                case let .success(popularMovies):
                    promise(.success(popularMovies))
                }
            }
            
            return Disposables.create { request.cancel() }
        }.asObservable()
    }

    private func parseError(_ error: AFError, expected: Error) -> Error {
        guard case AFError.sessionTaskFailed(let urlError) = error,
              let error = urlError as? URLError, error.code == URLError.Code.notConnectedToInternet
        else { return expected }
        return .notConnectedToInternet
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
    
    private func defaultParameters() -> [String: Any] {
        return ["api_key": apiKey]
    }
}
