//
//  TMDBPosterService.swift
//  Movies
//
//  Created by Andrii Hanchak on 06.10.2020.
//

import Alamofire
import UIKit

final class TMDBPosterService: PosterService {
    
    private let apiKey: String
    private let baseURL = URL(string: "https://image.tmdb.org")!
    private var cache: [String: URL] = [:]
    
    private var parameters: [String: Any] {
        return ["api_key": apiKey]
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getMoviePoster(_ movie: Movie, completion: @escaping (URL?) -> Void) {
        guard let url = cache[movie.posterPath]
        else { return downloadMoviePoster(movie, completion: completion) }
        
        completion(url)
    }
    
    private func downloadMoviePoster(_ movie: Movie, completion: @escaping (URL?) -> Void) {
        let destination = createMoviePosterFileDestination(movie)
        let url = baseURL.appendingPathComponent("/t/p/original\(movie.posterPath)")
        let request = AF.download(url,
                    parameters: parameters,
                    encoding: URLEncoding(destination: .queryString),
                    to: destination)
            
            
            
        request.response { [weak self] (response) in
            switch response.result {
            case .failure(_):
                completion(nil)
                
            case let .success(fileURL):
                self?.cache[movie.posterPath] = fileURL
                completion(fileURL)
            }
        }
    }
    
    private func createMoviePosterFileDestination(_ movie: Movie) -> DownloadRequest.Destination {
        return { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let name = movie.posterPath.replacingOccurrences(of: "/", with: "")
            let fileURL = documentsURL.appendingPathComponent(name)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
    }
}
